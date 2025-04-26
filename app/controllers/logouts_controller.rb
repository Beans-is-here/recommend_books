class LogoutsController < ApplicationController
  def show
    session.delete(:user_id)
    redirect_to users_path, notice: 'ログアウトしました'
  end
end
