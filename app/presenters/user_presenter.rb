class UserPresenter < Presenter

  presents_as :user

  def email
    user.email
  end

  def gravatar_md5
    Digest::MD5.hexdigest(user.email.to_s.downcase.strip)
  end

  def gravatar_tag
    image_tag "http://www.gravatar.com/avatar/#{gravatar_md5}?d=retro&s=64"
  end

  def as_json(options = {})
    {
      "id"        => user.id,
      "email"     => user.email,
    }
  end

end
