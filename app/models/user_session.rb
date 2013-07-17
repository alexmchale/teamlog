class UserSession

  include ActsLikeActiveRecord

  attr_reader :user, :email, :password

  def save
    @user ||= User.where("LOWER(email) = ?", email.to_s.strip.downcase).first
    @user.password == password
  end

  def self.create(attributes = {})
    user_session = UserSession.new(attributes)
    user_session if user_session.authorized?
  end

end
