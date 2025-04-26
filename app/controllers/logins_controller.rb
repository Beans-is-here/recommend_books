class LoginsController < ApplicationController
  def new
  end

  def create
    user = User.where(name: params[:name], email: params[:email]).first

    if user.present?
      session[:user_id] = user.id
      redirect_to users_path, notice: 'ログインしました'
    else
      flash.now[:warning] = 'ログインに失敗しました'
      render :new
    end
  end
end
