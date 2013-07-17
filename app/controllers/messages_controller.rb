class MessagesController < ApplicationController

  before_filter :check_logged_in!

  def index
    @messages = Message.order("created_at DESC").all.to_a
  end

  def new
    @message = Message.new
    @message.user = current_user
    @message.team = team
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @message.team = team

    if @message.save
      redirect_to team_path(team)
    else
      render "new"
    end
  end

  private

  def team
    @team ||= current_user.teams.find(params[:team_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
