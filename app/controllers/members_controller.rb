class MembersController < ApplicationController

  before_filter :check_logged_in!
  before_filter :load_team

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    @user ||= User.new(user_params)

    @user.skip_new_team = true

    if @user.save
      TeamUser.add_member(@team, @user)
      UserMailer.activate_message(current_user, @team, @user).deliver if @user.password_hash.blank?
      redirect_to @team
    else
      render "new"
    end
  end

  private

  def load_team
    @team = self.current_user.teams.find(params[:team_id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

end
