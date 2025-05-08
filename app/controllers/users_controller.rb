class UsersController < ApplicationController
  before_action :set_user, only: %i[ destroy ]

  def index
    @users = User.all
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
    @sign_up_form = SignUpForm.new(sign_up_form_params)
    puts "Attempting to save sign up form with: #{sign_up_form_params.inspect}"
    
    if @sign_up_form.save
      session[:user_id] = @sign_up_form.user.id
      redirect_to @sign_up_form.user, success: 'サインアップに成功'
    else
      Rails.logger.info @sign_up_form.errors.full_messages 
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("form_container", partial: "users/form", locals: { sign_up_form: @sign_up_form })
          puts "render_false"
        end
        format.html do
          flash.now[:danger] = 'サインアップに失敗'
          render :new
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @sign_up_form.update(user_params)
        format.html { redirect_to user_path, notice: "ユーザーが更新されました" }
        format.json { render :show, status: :ok, location: @sign_up_form }
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

  def set_user
    @user = User.find(params[:id])
  end

end
