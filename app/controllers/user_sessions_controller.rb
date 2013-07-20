class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)

    if @user_session.save
      self.current_user = @user_session.user
      flash[:notice] = "you are now signed in"
      redirect_to root_path
    else
      flash.now[:error] = "couldn't sign in"
      render :action => :new
    end
  end

  def destroy
    self.current_user = nil
    redirect_to new_user_session_path
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end

end
