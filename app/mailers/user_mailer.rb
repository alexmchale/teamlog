class UserMailer < ActionMailer::Base

  default from: "teamlog@anticlever.com"

  self.default_url_options = {
    :host => "zeus.local:3001",
  }

  def activate_message(inviter, team, user)
    @inviter = inviter
    @team    = team
    @user    = user
    mail :to => user.email, :subject => "StatusKeeper: You are invited to join #{team}"
  end

end
