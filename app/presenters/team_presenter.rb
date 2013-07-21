class TeamPresenter < Presenter

  presents_as :team

  def badges
    users = team.users.order("created_at ASC").to_a

    masonry_options = {
      "gutter"       => 10,
      "itemSelector" => ".user-badge",
      "isFitWidth"   => true,
    }

    raw <<-HTML
      <div class="user-badges-outer">
        <div class="user-badges-inner js-masonry" data-masonry-options="#{h masonry_options.to_json}">
          #{ present(users, :team => team) { |user| user.badge } }
        </div>
      </div>
    HTML
  end

end
