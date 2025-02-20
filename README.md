# Weather Search API App

Users can search for the weather of a location, displaying the lowest, highest, and current temperatures. The app caches the weather information by the address's zipcode to reduce the number of API calls.

## **Design Pattern**
1. **Weather Service**  
   - Handles API calls to the Weather API.  
   - Calculates latitude and longitude to fetch weather data for the location.

2. **CacheHelper Concern**  
   - Manages caching functionality.

3. **WeatherController**  
   - Contains `show` action to display the weather for a location.  
   - Allows users to search for weather.

## **Scalability Considerations
1.  **Clear the cached value if the hour changes to give accurate information
