class MembersController < ApplicationController

  before_filter :load_team

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    @user ||= User.new(user_params)

    if @user.save
      TeamUser.create(:team_id => @team.id, :user_id => @user.id)
      UserMailer.activate_message(@user).deliver if @user.password_hash.blank?
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
