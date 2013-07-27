Airbrake.configure do |config|
  config.api_key = '9a58b456daa033dc86229cc4a6262f87'
  config.host    = 'errbit.anticlever.com'
  config.port    = 80
  config.secure  = config.port == 443
end
