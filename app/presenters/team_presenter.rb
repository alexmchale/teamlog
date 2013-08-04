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
    team_users = team.members_including_most_recent_message

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
