class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @q = Book.ransack(params[:q])  # Ransackの検索オブジェクトを初期化
    @books = @q.result(distinct: true)  # 検索結果を取得
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to @book, notice: 'bookの登録が成功'
    else
      render :new
    end
  end

    def edit
    end

    def update
      @book.update(book_params)
      if @book.save
        redirect_to @book, notice: 'bookの編集が成功'
      end
    end

    def destroy
    end
 
    def ranking
      @all_ranks = Book.create_all_ranks
    end


    private

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
        params.require(:book).permit(:title, :description)
      end

end
