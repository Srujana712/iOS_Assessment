import Foundation
import Combine
import MapKit

//
///
/**
 TODO: Fill in this to retrieve current weather, and 5 day forecast
 * Use func currentWeatherURL(location: CLLocation) -> URL? to get the CurrentWeatherJSONData
 * Use func forecastURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL? to get the ForecastJSONData

 Once you have both the JSON Data, you can map:
 * CurrentWeatherJSONData -> CurrentWeatherDisplayData
 * ForecastJSONData ->ForecastDisplayData
 Both of these DisplayData structs contains the text you can bind/map to labels and we have included convience init that takes the JSON data so you can easily map them
 */
struct WeatherService {
  /// Example function signatures. Takes in location and returns publishers that contain
  var retrieveWeatherForecast: (CLLocation) -> DataPublisher<ForecastJSONData?>
  var retrieveCurrentWeather: (CLLocation) -> DataPublisher<CurrentWeatherJSONData?>
}

// Mofidifed and extended by Srujana
extension WeatherService {
  static var live = WeatherService(
    retrieveWeatherForecast: { location in
      guard let url = forecastURL(location: location) else {
        return Fail(error: SimpleError.dataLoad("Invalid URL for weather forecast")).eraseToAnyPublisher()
      }

      return URLSession.shared.dataTaskPublisher(for: url)
        .tryCompactMap({ element in
          guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw SimpleError.dataLoad(URLError(.badServerResponse).localizedDescription)
          }
          return try JSONDecoder().decode(ForecastJSONData.self, from: element.data)
        })
        .mapError({ SimpleError.dataParse($0.localizedDescription) })
        .eraseToAnyPublisher()
    },

    retrieveCurrentWeather: { location in
      guard let url = currentWeatherURL(location: location) else {
        return Fail(error: SimpleError.dataLoad("Invalid URL for current weather")).eraseToAnyPublisher()
      }

      return URLSession.shared.dataTaskPublisher(for: url)
        .tryCompactMap({ element in
          guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
            throw SimpleError.dataLoad(URLError(.badServerResponse).localizedDescription)
          }
          return try JSONDecoder().decode(CurrentWeatherJSONData.self, from: element.data)
        })
        .mapError({ SimpleError.dataParse($0.localizedDescription) })
        .eraseToAnyPublisher()
    }
  )
}
