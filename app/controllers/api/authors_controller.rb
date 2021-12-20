module Api
  class AuthorsController < ApplicationController
    def index
      authors = Author.all
      render json: authors
    end

    def show
      @author = Author.find(params[:id])
      render json: @author
    end

    def create
      @author = Author.new(author_params)
      if @author.save
        render json: { message: "Author added successfully" }, status: :ok
      else
        render json: { message: @author.errors.objects.first.full_message }, status: :bad_request
      end
    end

    private

    def author_params
      # raise ActionController::ParameterMissing if params.require(:author).blank?
      params.require(:author).permit(:name, :email, :phn_number)
    end
  end
end
