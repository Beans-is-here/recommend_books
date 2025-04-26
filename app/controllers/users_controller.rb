class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'ユーザーを新規登録しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, notice: "ユーザーが削除されました" }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
