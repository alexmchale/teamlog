class TeamsController < ApplicationController

  before_filter :check_logged_in!

  def index
    @teams = current_user.teams.alphabetical.all.to_a
  end

  def show
    @team = current_user.teams.find(params[:id])
    @users = @team.users.order("created_at ASC").to_a
    @messages = @team.messages.newest_first.to_a
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      TeamUser.create! user_id: current_user.id, team_id: @team.id
      flash[:notice] = "your team has been created"
      redirect_to team_path(@team)
    else
      render "new"
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

end
