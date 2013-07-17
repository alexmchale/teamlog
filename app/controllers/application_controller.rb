class ApplicationController < ActionController::Base

  protect_from_forgery

  helper_method :current_user

  def check_logged_in!
    redirect_to new_user_session_path unless current_user
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user

    if user
      session[:user_id] = user.id
    else
      session.delete :user_id
    end
  end

end
