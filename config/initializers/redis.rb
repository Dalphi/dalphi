require 'redis'

$redis = Redis.new(:url => "redis://#{ENV.fetch('REDIS_HOST', 'localhost')}:6379/0")
