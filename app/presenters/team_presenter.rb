class TeamPresenter < Presenter

  presents_as :team

  def badge
    raw <<-HTML
      <div class="badge-outer team-badge">
        <a href="#{h team_path(team)}">#{h team}</a>
      </div>
    HTML
  end

  def badges
    # messages = Message.current_team(team.id).includes(:team, :user).order("messages.created_at DESC").to_a

    columns = [
      "team_users.*",
      "messages.created_at AS message_created_at",
      "messages.content AS message_content",
    ]

    team_users =
      TeamUser.
        select("DISTINCT ON (team_users.id) #{columns.join ', '}").
        joins(:user, "LEFT JOIN messages ON team_users.id = messages.team_user_id").
        to_a

    team_users.sort! do |tu1, tu2|
      if    tu1.message_created_at.blank? then 1
      elsif tu2.message_created_at.blank? then -1
      else  tu2.message_created_at <=> tu1.message_created_at
      end
    end

    masonry_options = {
      "gutter"       => 10,
      "itemSelector" => ".user-badge",
      "isFitWidth"   => true,
    }

    raw <<-HTML
      <div class="user-badges-outer">
        <div class="user-badges-inner js-masonry" data-masonry-options="#{h masonry_options.to_json}">
          #{ present(team_users) { |team_user| team_user.badge } }
        </div>
      </div>
    HTML
  end

end
