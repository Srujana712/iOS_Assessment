//
//  SwiftUIWeatherSummaryViewModel.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Srujana Eega on 6/18/24.
//

import XCTest
import Combine
import CoreLocation
@testable import SwiftUIIntergrationProject

struct MockWeatherService {
  static func mockCurrentWeatherPublisher(location: CLLocation) -> AnyPublisher<CurrentWeatherJSONData?, SimpleError> {
    return Just(CurrentWeatherJSONData.createMock())
      .setFailureType(to: SimpleError.self)
      .eraseToAnyPublisher()
  }

  static func mockForecastPublisher(location: CLLocation) -> AnyPublisher<ForecastJSONData?, SimpleError> {
    return Just(ForecastJSONData.createMock())
      .setFailureType(to: SimpleError.self)
      .eraseToAnyPublisher()
  }

  static func mockFailurePublisher<T>() -> AnyPublisher<T, SimpleError> {
    return Fail(error: SimpleError.dataLoad("Failed to load data")).eraseToAnyPublisher()
  }
}

extension WeatherService {
  static var mock: WeatherService {
    WeatherService(
      retrieveWeatherForecast: MockWeatherService.mockForecastPublisher,
      retrieveCurrentWeather: MockWeatherService.mockCurrentWeatherPublisher
    )
  }

  static var mockFailure: WeatherService {
    WeatherService(
      retrieveWeatherForecast: { _ in MockWeatherService.mockFailurePublisher() }, retrieveCurrentWeather: { _ in MockWeatherService.mockFailurePublisher() }
    )
  }
}

final class SwiftUIWeatherSummaryViewModelTests: XCTestCase {

  var viewModel: WeatherSummaryViewModel!
  var cancellables: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    viewModel = WeatherSummaryViewModel(addressService: .mock, weatherService: .mockFailure)
    cancellables = []
  }

  override func tearDown() {
    viewModel = nil
    cancellables = nil
    super.tearDown()
  }

  func testFetchWeatherForAddressFailure() {
    // Create SearchText
    viewModel.searchText = "Invalid Address"

    let expectation = XCTestExpectation(description: "Fetch weather data failure")

    // Act
    viewModel.$currentWeather
      .dropFirst() // Skip the initial value
      .sink { currentWeather in
        // Assert
        if currentWeather == nil {
          expectation.fulfill()
        }
      }
      .store(in: &cancellables)

    viewModel.fecthWeatherForAddress()

    wait(for: [expectation], timeout: 5.0)
  }

  func testClearView() {
    // initialize/create the ViewModel with mock services
    // Dependency Injection is used for the same reason on how the view models can be tested by injected the mock service.
    viewModel = WeatherSummaryViewModel(addressService: .mock, weatherService: .mock)
    viewModel.searchText = "Valid Address"

    let expectation = XCTestExpectation(description: "Clear view")

    // Act
    viewModel.fecthWeatherForAddress()

    // Assert initial fetch
    viewModel.$currentWeather
      .dropFirst(1) // Skip the initial value
      .sink { currentWeather in
        if currentWeather != nil {
          // Set searchText to "" to trigger clearView()
          self.viewModel.searchText = ""
        } else {
          // After clearView is triggered, currentWeather should be nil
          XCTAssertNil(currentWeather)
          expectation.fulfill()
        }
      }
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 5.0)
  }

  func testFetchWeatherForAddressUpdatesForecast() {
    // create the mock viewModel by injection the mock service.
    // Dependency Injection is used for the same reason on how the view models can be tested by injected the mock service.
    viewModel = WeatherSummaryViewModel(addressService: .mock, weatherService: .mock)
    viewModel.searchText = "Valid Address"

    let expectation = XCTestExpectation(description: "Fetch weather forecast successfully")

    // Act
    viewModel.$forecastWeather
      .dropFirst() // Skip the initial value
      .sink { forecast in
        // Assert
        XCTAssertFalse(forecast.isEmpty)
        XCTAssertEqual(forecast.first?.temperatureText, "Temperature: 54F")
        expectation.fulfill()
      }
      .store(in: &cancellables)

    viewModel.fecthWeatherForAddress()
    wait(for: [expectation], timeout: 5.0)
  }
}
