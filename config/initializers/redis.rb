config = Rails.application.secrets.redis
Redis.current = Redis.new(config)