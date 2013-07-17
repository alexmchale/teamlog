class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.create(params[:user])

    if @user
      redirect_to root_path
    else
      flash.now[:error] = "couldn't create that user"
      render "new"
    end
  end

end
