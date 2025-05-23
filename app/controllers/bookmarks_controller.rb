class BookmarksController < ApplicationController
  before_action :require_login
  def create
    @book = Book.find(params[:book_id])
    current_user.bookmark(@book)
  end

  def destroy
    @book = current_user.bookmarks.find(params[:id]).book
    current_user.unbookmark(@book)
  end

  def index
    @bookmarked_books = current_user.bookmarks.includes(:book).map(&:book)
  end

  private
  def not_authenticated
    redirect_to new_login_path
  end
end