$ ->

  $newMessageField = $("#message_content")
  $newMessageForm  = $newMessageField.closest("form")
  $badgesContainer = $("#team_badges")
  $teamId          = $("#team_id")
  teamId           = $teamId.val()
  maxEmailWidth    = 220

  return unless teamId?

  integerKeyList = (object) ->
    _.map _.keys(object), (key) ->
      parseInt key, 10

  reflowContainer = ($container) ->
    $container.imagesLoaded ->
      # Adjust the font width of email addresses to fit.
      $container.find(".user-email-inner").each ->
        $userEmail = $(this)
        fontSize = 20
        while $userEmail.width() > maxEmailWidth
          $userEmail.css("font-size", "#{fontSize}px")
          fontSize -= 1
      # Reflow the masonry layout to account for changes.
      $container.masonry "layout"

  refreshTeamStatus = ->

    userBadges = $("#team_badges").find(".user-badge")
    userIds    = (parseInt($(user).data("user-id"), 10) for user in userBadges)

    $.getJSON "/teams/#{teamId}", (data) ->

      # The masonry container.
      $container = $badgesContainer.find(".user-badges-inner")

      # Turn the list of users into a hash.
      users = {}
      users[user.id] = user for user in data.users

      # Determine what's changed.
      existingUserIds = _.filter userIds, (id) -> users[id]
      newUserIds      = _.filter integerKeyList(users), (id) -> userIds.indexOf(id) == -1
      oldUserIds      = _.filter userIds, (id) -> users[id] == undefined

      # Update existing users.
      for id in existingUserIds
        user = users[id]
        $badge = $(".user-badge[data-user-id=#{id}]")
        $message = $badge.find(".user-message")
        $message.text user.message || ""
        $timestamp = $badge.find(".user-timestamp")
        $timestamp.text user.timestamp || ""

      # Add new users.
      for id in newUserIds
        user = users[id]
        $badge = $(user.badge)
        $container.append($badge).masonry("appended", $badge)

      # Remove old users.
      for id in oldUserIds
        badge = _.find userBadges, (b) -> b.getAttribute("data-user-id") == id.toString()
        $container.masonry "remove", badge

      # Reflow our masonry layout to account for any changes in badge size.
      reflowContainer($container)

  $newMessageForm.on "submit", ->
    url = $newMessageForm.attr("action")
    $.ajax
      type:    "POST"
      url:     url
      data:    $newMessageForm.serialize()
      success: -> refreshTeamStatus() ; $newMessageField.val("")
    return false

  reflowContainer($("#team_badges .user-badges-inner"))

  joinTeam(teamId, refreshTeamStatus)
