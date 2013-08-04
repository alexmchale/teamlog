class TeamUserPresenter < Presenter

  presents_as :team_user

  def badge
    raw <<-HTML
      <div class="badge-outer user-badge" data-user-id="#{h team_user.user_id}">
        #{user_presenter.gravatar_tag}
        <div class="user-email"><span class="user-email-inner">#{h user_presenter.email}</span></div>
        <span class="user-message">#{h team_user.message_content}</span>
        <span class="user-timestamp">#{h team_user.message_created_at}</span>
      </div>
    HTML
  end

  def user_presenter
    @user_presenter ||=
      UserPresenter.new(team_user.user, @template).tap do |presenter|
        presenter.team = team_user.team
      end
  end

  def last_message
    @last_message ||= Message.where(user_id: user.id, team_id: team.id).newest_first.first
  end

  def content
    message.content
  end

  def created_at
    "#{time_ago_in_words(message.created_at)} ago"
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
