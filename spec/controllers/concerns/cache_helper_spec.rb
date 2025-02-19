require 'rails_helper'

RSpec.describe CacheHelper do
  let(:address) { '1152 Harwell Loop, Kyle, Texas 78640' }
  let(:weather_service) { WeatherService.new(address) }
  let(:zipcode) { weather_service.zipcode }

  before { Rails.cache.clear }
  describe '#cache_value' do
    it 'caches the value' do
      weather_service.cache_value(zipcode, 'cached value')
      expect(weather_service.cached_value(zipcode)).to eq('cached value')
    end

    it 'returns nil if the value is not cached' do
      expect(weather_service.cached_value(zipcode)).to be_nil
    end
  end

  describe '#fetch_cached_value' do
    it 'returns the cached value' do
      weather_service.cache_value(address, 'cached value')
      expect(weather_service.fetch_cached_value(address)).to eq('cached value')
    end
  end

  describe '#cache_or_fetch' do
    it 'caches the value' do
      expect(weather_service.cache_or_fetch(address, 'cached value')).to eq('cached value')
    end
    it 'returns the cached value' do
      weather_service.cache_value(address, 'cached value')
      expect(weather_service.cache_or_fetch(address, 'cached value')).to eq('cached value')
    end
  end
end
