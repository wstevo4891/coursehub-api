# Determine the Redis URL based on the environment
redis_url = ENV.fetch("SIDEKIQ_REDIS_URL", "redis://localhost:6379/0")

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }

  # Add database logging for Sidekiq
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
