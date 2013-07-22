class UserPresenter < Presenter

  presents_as :user

  attr_accessor :team

  def badge
    raw <<-HTML
      <div class="user-badge">
        #{gravatar_tag}
        <span class="user-email">#{h user.email}</span>
        #{h last_message}
      </div>
    HTML
  end

  def last_message
    Message.where(user_id: user.id, team_id: team.id).newest_first.first.try(:content)
  end

  def gravatar_md5
    Digest::MD5.hexdigest(user.email.to_s.downcase.strip)
  end

  def gravatar_tag
    image_tag "http://www.gravatar.com/avatar/#{gravatar_md5}?d=retro&s=80"
  end

end