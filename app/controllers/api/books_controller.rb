module Api
  class BooksController < ApplicationController
    # before_action :authenticate_user!, except: [:index]
    before_action :set_book, only: [:show, :update, :destroy]

    def index
      render json: Book.joins(:author).select("id", "title", "authors.name as author_name")
    end

    def search
      render json: Book.joins(:author).where("title LIKE ?", "%" + params[:q] + "%").select("id", "title", "authors.name as author_name")
    end

    def show
      render json: { book: @book, author: @book.author }
    end

    def create
      @book = Book.new(book_params)
      if @book.save
        render json: { message: "Book added successfully" }, status: :ok
      else
        render json: { message: @book.errors.objects.first.full_message }, status: :bad_request
      end
    end

    def update
      if @book.update(book_params)
        render json: { book: @book, author: @book.author }
      else
        render json: @book.errors
      end
    end

    def destroy
      if @book.destroy
        render json: { message: "Book Deleted successfully" }, status: :ok
      else
        render json: { message: @book.errors.objects.first.full_message }, status: :bad_request
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
