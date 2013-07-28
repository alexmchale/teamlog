class PasswordResetsController < ApplicationController

  before_filter :load_user, :only => %w( edit update )

  def new
    @password_reset = PasswordReset.new
  end

  def create
    @password_reset = PasswordReset.new(password_reset_params)

    if @password_reset.save
      flash[:notice] = "We've emailed you a link to reset your password."
      redirect_to new_user_session_path
    else
      flash.now[:error] = "That email address wasn't in our records."
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      @user.update_column :secret_code, nil
      self.current_user = @user
      redirect_to root_path
    else
      render "edit"
    end
  end

  private

  def password_reset_params
    params.require(:password_reset).permit(:email)
  end

  def user_params
    params.require(:user).permit(:password)
  end

  def load_user
    @user = User.find_by_secret_code(params[:id]) if params[:id].present?

    if @user == nil
      flash[:error] = "That secret code has expired. Please request a new password reset and try again."
      redirect_to new_password_reset_path
    end
  end

end
