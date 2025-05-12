class BooksController < ApplicationController

  def index
    @q = Book.ransack(params[:q])  # Ransackの検索オブジェクトを初期化

    if params[:tag_map] && [:tag_id]
      puts "before search"
      @books = @q.result.joins(:tag_maps).where(tag_maps: { tag_id: params[:tag_map][:tag_id] })
      puts "after search"
    else
      puts "test if"
    @books = @q.result.includes(:tags).order(created_at: :desc).distinct # 検索結果を取得
  end
end

  def show
    @book = Book.find(params[:id])
    @tags = @book.tags
    @related_books = Book.joins(:tags).where(tags: { id: @tags.pluck(:id) }).where.not(id: @book.id)
  end

  def new
    @book = Book.new
  end

  def create
    puts params.inspect
    puts book_params.inspect
    puts tag_params.inspect
  
    @user = current_user
    puts @user
    if @user
      @book = @user.books.new(book_params)
      puts @book
  
      puts "Before save"
      if @book.save
        # ここでタグを作成する
        input_tags = tag_params[:tag_name].present? ? tag_params[:tag_name].split(",") : []
        @book.create_tags(input_tags)
        @input_tags = input_tags.join(",")
        
        redirect_to book_path(@book), notice: 'bookの登録が成功'
      else
        puts "Errors: #{@book.errors.full_messages.join(', ')}"
        flash.now[:danger] = 'bookの登録に失敗'
        render :new
      end
    else
      puts "Errors: User not found"
      flash.now[:danger] = '指定されたユーザーが見つかりません。'
      render :new
    end
  end
  
    def edit
      @book = current_user.books.find(params[:id])
      @input_tags = @book.tags.pluck(:tag_name).join(",")
      puts i=@input_tags
    end

    def update
      @book = current_user.books.find(params[:id])
      input_tags = tag_params[:tag_name].split(",")
      @book.update_tags(input_tags)
      if @book.update(book_params)
        redirect_to book_path(@book), notice: 'bookの編集が成功'
      else
        flash.now[:danger] = 'bookの編集に失敗'
        render :edit
      end
    end

    def destroy
      @user = current_user
      @book = @user.books.find_by(params[:id])

      if @book
      @book.destroy!
      redirect_to books_path, success: 'bookを削除'
      else
        flash[:alert] = "bookが見つからない"
        redirect_to books_path
      end
    end
 
    def ranking
      @all_ranks = Book.create_all_ranks
    end

    private

    def book_params
      params.require(:book).permit(:title, :description)
    end

    def tag_params
      params.require(:tag).permit(:tag_name)
    end
end
