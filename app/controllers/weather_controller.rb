class WeatherController < ApplicationController
  include CacheHelper

  before_action :set_address, only: %i[show]

  def show
    return if @address.blank?

    service = WeatherService.new(@address)
    @weather_data = service.fetch_weather_data
    Rails.logger.info(@address)
    if @weather_data.blank?
      flash.now[:error] = 'Weather is not avaliable for this address'
      return
    end
    cache_value(service.zipcode, @weather_data)
    @lowest_temperature, @highest_temperature, @current_temperature = @weather_data
  rescue StandardError => e
    flash.now[:error] = "class: #{e.class}, #{e.message}"
  end

  private

  def weather_params
    params.permit(:address, :commit, :controller, :action)
  end

  def set_address
    @address = weather_params[:address]
    nil if @address.blank?
  end
end
