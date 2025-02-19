# write a service spec for WeatherService
require 'rails_helper'

RSpec.describe WeatherService do
  let(:address) { '1152 Harwell Loop, Kyle, Texas 78640' }
  let(:weather_service) { WeatherService.new(address) }

  describe '#calculate_lat_long' do
    it 'returns the latitude and longitude of the address' do
      expect(weather_service.calculate_lat_long).to eq([30.019437163968767, -97.88249491379516])
    end

    it 'returns an error message if the address is invalid' do
      allow(Geocoder).to receive(:search).and_return([])
      expect(weather_service.calculate_lat_long).to eq({ error: 'Invalid Address' })
    end
  end

  describe '#fetch_weather_data' do
    it 'returns the lowest, highest, and current temperature' do
      expect(weather_service.fetch_weather_data).to eq([-4.4, 9.3, -0.4])
    end

    it 'returns an error message if the address is invalid' do
      allow(Geocoder).to receive(:search).and_return([])
      expect(weather_service.fetch_weather_data).to eq({ error: 'Invalid Address' })
    end
  end

  describe '#set_tempertures' do
    it 'returns the lowest, highest, and current temperature' do
      expect(weather_service.set_tempertures).to eq([50.0, 70.0, 60.0])
    end
  end

  describe '#today_temperature_array' do
    it 'returns an array of temperatures for the day' do
      expect(weather_service.today_temperature_array).to eq([-4.4, 9.3, -0.4])
    end
  end

  describe '#check_cache' do
    it 'returns the cached value' do
      Rails.cache.write(address, 'cached value')
      expect(weather_service.check_cache).to eq("cached value'")
    end
  end

  describe 'zipcode' do
    it 'returns the zipcode of the address' do
      expect(weather_service.zipcode).to eq('78640')
    end

    it 'returns an error message if the address is invalid' do
      allow(Geocoder).to receive(:search).and_return([])
      expect(weather_service.zipcode).to eq({ error: 'Invalid Address' })
    end
  end
end
