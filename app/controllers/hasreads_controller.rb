class HasreadsController < ApplicationController
    def create
      @book = Book.find(params[:book_id])
      current_user.hasread(@book)
    end
  
    def destroy
      @book = current_user.hasreads.find(params[:id]).book
      current_user.unhasread(@book)
    end
  end