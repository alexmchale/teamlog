# Generate a random secret token and store it in the config directory. If you
# need to change the secret token, just delete config/secret_token.txt and
# restart your app.

secret_token_path = Rails.root.join "config", "secret_token.txt"

unless File.exists? secret_token_path
  secret_token = SecureRandom.hex 64
  File.open(secret_token_path, "w") { |f| f.write secret_token }
end

RailsSkeleton::Application.config.secret_token = File.read secret_token_path
