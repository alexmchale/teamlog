class PasswordReset

  include ActsLikeActiveRecord

  attr_reader :user, :email

  def save
    @user = User.find_by_email(@email)

    if @user
      @user.grant_new_secret_code!
      UserMailer.password_reset_message(@user).deliver
    end

    @user != nil
  end

end
