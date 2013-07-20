class UserMailer < ActionMailer::Base

  default from: "teamlog@anticlever.com"

  self.default_url_options = {
    :host => "zeus.local:3001",
  }

  def activate_message(user)
    @user = user
    mail :to => user.email, :subject => "please activate your teamlog account"
  end

end
