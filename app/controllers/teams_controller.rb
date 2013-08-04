class TeamsController < ApplicationController

  before_filter :check_logged_in!

  def index
    @teams = current_user.teams.alphabetical.all.to_a
    redirect_to team_path(@teams.first) if @teams.length == 1
  end

  def show
    @team        = current_user.teams.find(params[:id])
    @users       = @team.users
    @new_message = Message.new

    respond_to do |format|
      format.html do
        if request.xhr?
          render :text => TeamPresenter.new(@team, view_context).badges, :layout => false
        end
      end

      format.json do
        user_presenters = @users.map { |u| UserPresenter.new u, view_context }
        user_presenters.each { |u| u.team = @team }

        render :json => { :team => @team, :users => user_presenters }
      end
    end
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
