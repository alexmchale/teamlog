port    = parseInt(process.argv[2], 10)
io      = require("socket.io").listen(port)
redis   = require("redis").createClient(6379, "db.local")
logger  = io.log

class Client
  constructor: (@socket) ->
    @team = null
    @socket.on "teamlog.join-team", @joinTeam
    @socket.on "disconnect", @disconnect
  joinTeam: (teamId) =>
    logger.info "client joining team #{teamId}"
    @team?.dropClient(@)
    @team = Team.find(teamId)
    @team.addClient(@)
  disconnect: =>
    @team.dropClient(@) if @team?
    @team = null
  sendAlert: (message) =>
    @socket.emit "teamlog.alert", message

Client.find = (socket) ->
  Client.clients ?= []
  for client in Client.clients
    return client if client.socket == socket
  client = new Client(socket)
  Client.clients.push(client)
  return client

class Team
  constructor: (@id) ->
    @clients = []
  addClient: (client) =>
    @clients.push(client)
  dropClient: (client) =>
    @clients = (c for c in @clients when c != client)
  sendAlert: =>
    logger.info "alerting #{@id} to #{@clients.length} clients"
    c.sendAlert("{team_id: #{@id}}") for c in @clients

Team.find = (teamId) ->
  Team.teams ?= []
  for team in Team.teams
    return team if team.id == teamId
  team = new Team(teamId)
  Team.teams.push(team)
  return team

class TeamAlertListener
  constructor: (@redis) ->
    @listen()
  listen: =>
    @redis.blpop "teamlog:team-alert", 0, (err, [queue, teamId]) =>
      logger.info "got alert: #{teamId}"
      Team.find(teamId).sendAlert()
      @listen()

handleSocketConnection = (socket) ->
  logger.info "new socket connected: #{socket}"
  Client.find(socket)

handleRedisConnection = (socket) ->
  logger.info "redis connected"
  io.sockets.on "connection", handleSocketConnection
  new TeamAlertListener(redis)

handleRedisDisconnection = ->
  logger.info "redis disconnected, dying"
  process.exit 10

redis.on "connect", handleRedisConnection
redis.on "error", handleRedisDisconnection
redis.on "end", handleRedisDisconnection
