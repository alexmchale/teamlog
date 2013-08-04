class TeamUserPresenter < Presenter

  presents_as :team_user

  delegate :team, :to => :team_user
  delegate :user, :to => :team_user

  def badge
    raw <<-HTML
      <div class="badge-outer user-badge" data-user-id="#{h team_user.user_id}">
        #{user_presenter.gravatar_tag}
        <div class="user-email"><span class="user-email-inner">#{h user_presenter.email}</span></div>
        <span class="user-message">#{h content}</span>
        <span class="user-timestamp">#{h created_at}</span>
      </div>
    HTML
  end

  def user_presenter
    @user_presenter ||= UserPresenter.new(team_user.user, @template)
  end

  def content
    team_user.message_content
  end

  def created_at
    "#{time_ago_in_words(team_user.message_created_at)} ago"
  end

  def as_json(options = {})
    {
      "id"        => user.id,
      "email"     => user.email,
      "badge"     => badge,
      "message"   => content,
      "timestamp" => created_at,
    }
  end

end
