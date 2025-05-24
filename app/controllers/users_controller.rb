require 'net/http'
require 'uri'

class UsersController < ApplicationController
  before_action :set_user, only: %i[ destroy ]

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to users_path, alert: "ユーザーが見つかりませんでした"
      return
    end
  end

  def new
    @sign_up_form = SignUpForm.new
  end

  def create
    github_username = params[:sign_up_form][:name] 
    puts "取得したGitHubユーザー名: #{github_username}" # デバッグ用
    if valid_github_user?(github_username)

      @sign_up_form = SignUpForm.new(sign_up_form_params)
    puts "Attempting to save sign up form with: #{sign_up_form_params.inspect}"
    
      if @sign_up_form.save
        session[:user_id] = @sign_up_form.user.id
        redirect_to @sign_up_form.user, success: 'サインアップに成功'
      else
        @sign_up_form.errors.full_messages 
      end

    else
      flash.now[:alert] = 'GitHubユーザーではありません。'
      redirect_to new_user_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(edit_params)
        format.html { redirect_to user_path, notice: "ユーザーが更新されました" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sign_up_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, notice: "ユーザーが削除されました" }
      format.json { head :no_content }
    end
  end

  private

  def sign_up_form_params
    params.require(:sign_up_form).permit(:name, :email, :password, :password_confirmation)
  end

  def edit_params
    params.require(:user).permit(:name, :email)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def valid_github_user?(name)
    puts "CALL valid"
    uri = URI.parse("https://github.com/#{name}")
    response = Net::HTTP.get_response(uri)
    response.code == "200" # ステータスコードが200ならtrueを返す
  end
end
