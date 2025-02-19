class WeatherService
  include CacheHelper

  def initialize(address)
    @address = address
  end

  def calculate_lat_long
    # This method will calculate the latitude and longitude of the address
    location = Geocoder.search(@address)

    return { error: 'Invalid Address' } if location.blank?

    Rails.logger.info("location: #{location}")
    location.first.coordinates
  end

  def fetch_weather_data
    return cached_value if check_cache.present?

    lat, long = calculate_lat_long
    return { error: 'Invalid Address' } if lat.blank? || long.blank?

    url = "#{ENV.fetch('WEATHER_API_URL',
                       nil)}?latitude=#{lat}&longitude=#{long}#{ENV.fetch('WEATHER_API_OPTIONS', nil)}"
    response = HTTParty.get(url)

    @weather_data = JSON.parse(response.body)
    set_tempertures
  end

  def set_tempertures
    highest_temperature = today_temperature_array.max
    lowest_temperature = today_temperature_array.min
    current_temperature = @weather_data['current']['temperature_2m']

    [lowest_temperature, highest_temperature, current_temperature]
  end

  def today_temperature_array
    @weather_data.dig('hourly', 'temperature_2m')[0..23]
  end

  def check_cache
    cached_value = fetch_cached_value(@address)

    return unless cached_value.present?

    @weather_data = cached_value
  end

  def zipcode
    # This method will return the zipcodes of the address
    location = Geocoder.search(@address)

    return { error: 'Invalid Address' } if location.blank?

    location.first.data['address']['postcode']
  end
end
