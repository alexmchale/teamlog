class UserActivationsController < ApplicationController

  before_filter -> { self.current_user = nil }
  before_filter :load_user

  def edit
  end

  def update
    @user.attributes = user_params
    @user.secret_code = nil

    if @user.save
      self.current_user = @user
      redirect_to root_path
    else
      render "edit"
    end
  end

  private

  def load_user
    @user = User.where(params.slice :id, :secret_code).first

    if @user.try(:secret_code).blank?
      flash[:error] = "That secret code is invalid."
      redirect_to root_path
    end
  end

  def user_params
    params.require("user").permit("password")
  end

end
