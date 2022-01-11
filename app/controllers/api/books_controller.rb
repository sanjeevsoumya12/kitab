module Api
  class BooksController < ApplicationController
    before_action :authenticate_user!, except: [:index, :search]
    before_action :set_book, only: [:show, :update, :destroy]

    def index
      render json: Book.joins(:author).select("id", "title", "authors.name as author_name")
    end

    def search
      render json: Book.joins(:author).where("title LIKE ? or authors.name LIKE ?", "%" + params[:q] + "%", "%" + params[:q] + "%").select("id", "title", "authors.name as author_name")
      # render json: Book.joins(:author).where("title = ?", params[:title]).select("id", "title", "authors.name as author_name")
    end

    def show
      render json: { book: @book, author: @book.author }
    end

    # for admin access
    # def show
    #   if (current_user && current_user.admin)
    #     render json: { book: @book, author: @book.author }
    #   else
    #     render json: { message: "you have not access for this" }
    #   end
    # end

    def create
      @book = Book.new(book_params)
      if (current_user && current_user.admin)
        if @book.save
          render json: { message: "Book added successfully" }, status: :ok
        else
          render json: { message: @book.errors.objects.first.full_message }, status: :bad_request
        end
      else
        render json: { message: "you are not access to it" }
      end
    end

    def update
      if (current_user && current_user.admin)
        if @book.update(book_params)
          render json: { book: @book, author: @book.author }
        else
          render json: @book.errors
        end
      else
        render json: { message: "you are not access to it" }
      end
    end

    def destroy
      if (current_user && current_user.admin)
        if @book.destroy
          render json: { message: "Book Deleted successfully" }, status: :ok
        else
          render json: { message: @book.errors.objects.first.full_message }, status: :bad_request
        end
      else
        render json: { message: "you are not access to it" }
      end
    end

    private

    def set_book
      @book = Book.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: "Book not found" }, status: :not_found
    end

    def book_params
      # raise ActionController::ParameterMissing if params.require(:book).blank?
      params.require(:book).permit(:title, :price, :publishing_date, :author_id)
    end
  end
end
