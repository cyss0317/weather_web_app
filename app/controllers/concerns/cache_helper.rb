module CacheHelper
  extend ActiveSupport::Concern

  CACHE_EXPIRATION_TIME = 30.minutes

  def cache_value(key, value, expiration = CACHE_EXPIRATION_TIME)
    Rails.cache.write(key, value, expires_in: expiration)
  end

  def cached_value(key)
    Rails.cache.fetch(key)
  end

  def fetch_cached_value(key)
    Rails.cache.read(key)
  end

  def cache_or_fetch(key, value, expiration = CACHE_EXPIRATION_TIME)
    if fetch_cached_value(key).present?
      cached_value(key)
    else
      cache_value(key, value, expiration)
      value
    end
  end
end
