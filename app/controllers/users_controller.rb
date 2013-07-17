class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user
      redirect_to root_path
    else
      flash.now[:error] = "couldn't create that user"
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
