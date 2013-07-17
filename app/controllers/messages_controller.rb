class MessagesController < ApplicationController

  before_filter :check_logged_in!

  def index
    @messages = Message.order("created_at DESC").all.to_a
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user

    if @message.save
      redirect_to messages_path
    else
      render "new"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

end
