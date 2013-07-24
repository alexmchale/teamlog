class UserPresenter < Presenter

  presents_as :user

  attr_accessor :team

  def badge
    raw <<-HTML
      <div class="user-badge" data-user-id="#{h user.id}">
        #{gravatar_tag}
        <div class="user-email"><span class="user-email-inner">#{h user.email}</span></div>
        <span class="user-message">#{h last_message_content}</span>
        <span class="user-timestamp">#{h last_message_timestamp}</span>
      </div>
    HTML
  end

  def last_message
    @last_message ||= Message.where(user_id: user.id, team_id: team.id).newest_first.first
  end

  def last_message_content
    last_message.try(:content)
  end

  def last_message_timestamp
    "#{time_ago_in_words(last_message.created_at)} ago" if last_message
  end

  def gravatar_md5
    Digest::MD5.hexdigest(user.email.to_s.downcase.strip)
  end

  def gravatar_tag
    image_tag "http://www.gravatar.com/avatar/#{gravatar_md5}?d=retro&s=80"
  end

  def as_json(options = {})
    {
      "id"        => user.id,
      "email"     => user.email,
      "badge"     => badge,
      "message"   => last_message_content,
      "timestamp" => last_message_timestamp,
    }
  end

end
