class UsersController < ApplicationController

  before_filter :load_team

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    @existing_user = User.find_by_email(@user.email)

    if @existing_user && @team
      @existing_user.add_to_team @team
      redirect_to @team
    elsif @user.save
      @user.add_to_team @team
      self.current_user ||= @user
      redirect_to @team || root_path
    else
      flash.now[:error] = "couldn't create that user"
      render "new"
    end
  end

  private

  def load_team
    @team ||= Team.find_by_id(params[:team_id])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
