namespace :cache do
  CLEAR_BATCH_SIZE = 1000 # The more the faster, but having too many can crash Ruby
  REDIS_SCAN_START_STOP = '0' # Magic value, see http://redis.io/commands/scan

  desc "GitLab | Clear redis cache"
  task :clear => :environment do
    redis_store = Rails.cache.instance_variable_get(:@data)
    cursor = REDIS_SCAN_START_STOP
    loop do
      cursor, keys = redis_store.scan(
        cursor,
        match: "#{Gitlab::REDIS_CACHE_NAMESPACE}*", 
        count: CLEAR_BATCH_SIZE
      )

      redis_store.del(*keys) if keys.any?

      break if cursor == REDIS_SCAN_START_STOP
    end
  end
end
