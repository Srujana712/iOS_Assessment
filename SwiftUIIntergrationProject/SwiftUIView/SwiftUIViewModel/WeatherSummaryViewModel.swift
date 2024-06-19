//
//  WeatherSummaryViewModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Srujana Eega on 6/15/24.
//

import SwiftUI
import Combine

class WeatherSummaryViewModel: ObservableObject {
  @Published var searchText: String = "" {
    didSet {
      if searchText.isEmpty {
        clearView()
      }
    }
  }

  @Published private(set) var currentWeather: CurrentWeatherDisplayData?
  @Published private(set) var forecastWeather = [ForecastItemDisplayData]()
  @Published var errorMessage: String?

  private var cancellables: Set<AnyCancellable> = []
  private let addressService: AddressService
  private var weatherService: WeatherService

  init(addressService: AddressService = .live, weatherService: WeatherService = .live) {
    self.addressService = addressService
    self.weatherService = weatherService
  }

  func fecthWeatherForAddress() {
    cancelRequests()
    addressService.coordinatePublisher(searchText)
      .compactMap { $0 }
      .flatMap { location in
        Publishers.Zip(
          self.weatherService.retrieveCurrentWeather(location),
          self.weatherService.retrieveWeatherForecast(location)
        )
      }
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: {[weak self] completion in
        switch completion {
        case .failure(let error):
          self?.errorMessage = "Weather fetch failed"
          print("Fetching the weather details failed due to: \(error)")
          self?.clearView() // Clear view on failure
        case .finished:
          break
        }
      }) { [weak self] currentWeatherData, forecastData in
        if let currentWeatherData = currentWeatherData {
          self?.currentWeather = CurrentWeatherDisplayData(from: currentWeatherData)
        }

        if let forecastData = forecastData {
          self?.forecastWeather = ForecastDisplayData(from: forecastData).forecastItems
        }
      }
      .store(in: &cancellables)
  }

  func clearView() {
    currentWeather = nil
    forecastWeather = []
    cancelRequests()
  }

  func cancelRequests() {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
  }
}
