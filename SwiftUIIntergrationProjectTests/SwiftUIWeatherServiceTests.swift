//
//  WeatherServiceTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Srujana Eega on 6/17/24.
//

import XCTest
import Combine
import CoreLocation
@testable import SwiftUIIntergrationProject

final class SwiftUIWeatherServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testRetrieveCurrentWeatherSuccess() {
        // Create Mock Service
        let mockCurrentWeather = CurrentWeatherJSONData.createMock()
        let weatherService = WeatherService(
          retrieveWeatherForecast: { _ in
            Fail(error: SimpleError.dataLoad("Should not be called"))
              .eraseToAnyPublisher()
          }, retrieveCurrentWeather: { _ in
            Just(mockCurrentWeather)
              .setFailureType(to: SimpleError.self)
              .eraseToAnyPublisher()
          }
        )

        let expectation = XCTestExpectation(description: "Fetch current weather data")

        // Test the succcess case for the current weather
        weatherService.retrieveCurrentWeather(CLLocation(latitude: 38.9151, longitude: -77.2206))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Failed with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { currentWeather in
                // Assert
                XCTAssertNotNil(currentWeather)
                XCTAssertEqual(currentWeather?.name, "Tysons Corner")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testRetrieveCurrentWeatherFailure() {
      // Test the failure case for the current weather
        let weatherService = WeatherService(
          retrieveWeatherForecast: { _ in
            Fail(error: SimpleError.dataLoad("Should not be called"))
              .eraseToAnyPublisher()
          }, retrieveCurrentWeather: { _ in
            Fail(error: SimpleError.dataLoad("Failed to load data"))
              .eraseToAnyPublisher()
          }
        )

        let expectation = XCTestExpectation(description: "Fetch current weather data failure")

        // Act
        weatherService.retrieveCurrentWeather(CLLocation(latitude: 38.9151, longitude: -77.2206))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // Assert
                    XCTAssertEqual(error, SimpleError.dataLoad("Failed to load data"))
                    expectation.fulfill()
                case .finished:
                    XCTFail("Should have failed")
                }
            }, receiveValue: { _ in
                XCTFail("Should not have received value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testRetrieveWeatherForecastSuccess() {
      // Test the succcess case for the forecast weather
        let mockForecast = ForecastJSONData.createMock()
        let weatherService = WeatherService(
          retrieveWeatherForecast: { _ in
            Just(mockForecast)
              .setFailureType(to: SimpleError.self)
              .eraseToAnyPublisher()
          }, retrieveCurrentWeather: { _ in
            Fail(error: SimpleError.dataLoad("Should not be called"))
              .eraseToAnyPublisher()
          }
        )

        let expectation = XCTestExpectation(description: "Fetch weather forecast data")

        // Act
        weatherService.retrieveWeatherForecast(CLLocation(latitude: 38.9151, longitude: -77.2206))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Failed with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { forecast in
                // Assert
                XCTAssertNotNil(forecast)
                XCTAssertEqual(forecast?.city.name, "Tysons Corner")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }

    func testRetrieveWeatherForecastFailure() {
      // Test the failure case for the forecast weather
        let weatherService = WeatherService(
          retrieveWeatherForecast: { _ in
            Fail(error: SimpleError.dataLoad("Failed to load data"))
              .eraseToAnyPublisher()
          }, retrieveCurrentWeather: { _ in
            Fail(error: SimpleError.dataLoad("Should not be called"))
              .eraseToAnyPublisher()
          }
        )

        let expectation = XCTestExpectation(description: "Fetch weather forecast data failure")

        // Create
        weatherService.retrieveWeatherForecast(CLLocation(latitude: 38.9151, longitude: -77.2206))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // Assert
                    XCTAssertEqual(error, SimpleError.dataLoad("Failed to load data"))
                    expectation.fulfill()
                case .finished:
                    XCTFail("Should have failed")
                }
            }, receiveValue: { _ in
                XCTFail("Should not have received value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}
