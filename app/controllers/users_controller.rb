class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      self.current_user ||= @user
      redirect_to root_path
    else
      flash.now[:error] = "couldn't create that user"
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_team_name)
  end

end
