@socket       = io.connect("http://localhost:8080")
alertCallback = null

@joinTeam = (teamId, callback) =>
  alertCallback = callback
  @socket.emit "teamlog.join-team", teamId

@socket.on "teamlog.alert", ->
  alertCallback() if alertCallback?
