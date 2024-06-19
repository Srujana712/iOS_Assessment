//
//  SwiftUIForecastSummaryViewModel.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Srujana Eega on 6/18/24.
//

import XCTest
@testable import SwiftUIIntergrationProject

struct MockForecastItemDisplayData {
    static func createMock() -> ForecastItemDisplayData {
        return ForecastItemDisplayData(
            id: "123",
            timeDateText: "2023-06-15 03:00:00",
            temperatureText: "Temperature: 59.65°F",
            weatherText: "Weather: broken clouds",
            windSpeedText: "Wind Speed: 3.44 mph",
            windDirectionText: "Wind Direction: 150°",
            rainText: "Rain: 0.1 mm"
        )
    }
}

final class SwiftUIForecastCardViewModelTests: XCTestCase {

  var viewModel: ForecastCardViewModel!

      override func setUp() {
          super.setUp()
          let mockData = MockForecastItemDisplayData.createMock()
          viewModel = ForecastCardViewModel(forecastItemData: mockData)
      }

      override func tearDown() {
          viewModel = nil
          super.tearDown()
      }

      func testDateTimeText() {
          let dateTimeText = viewModel.dateTimeText
          XCTAssertEqual(dateTimeText, "2023-06-15 03:00:00")
      }

      func testTemperatureText() {
          let temperatureText = viewModel.temperatureText
          XCTAssertEqual(temperatureText, "Temperature: 59.65°F")
      }

      func testWeatherText() {
          let weatherText = viewModel.weatherText
          XCTAssertEqual(weatherText, "Weather: broken clouds")
      }

      func testWindSpeedText() {
          let windSpeedText = viewModel.windSpeedText
          XCTAssertEqual(windSpeedText, "Wind Speed: 3.44 mph")
      }

      func testWindDirectionText() {
          let windDirectionText = viewModel.windDirectionText
          XCTAssertEqual(windDirectionText, "Wind Direction: 150°")
      }

      func testRainText() {
          let rainText = viewModel.rainText
          XCTAssertEqual(rainText, "Rain: 0.1 mm")
      }
  }
