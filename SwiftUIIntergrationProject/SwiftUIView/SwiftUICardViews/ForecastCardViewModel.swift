//
//  ForecastCardViewModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Srujana Eega on 6/16/24.
//

import SwiftUI

class ForecastCardViewModel {
 private var forecastItemData: ForecastItemDisplayData

  init(forecastItemData: ForecastItemDisplayData) {
    self.forecastItemData = forecastItemData
  }

  var dateTimeText: String {
    return forecastItemData.timeDateText
  }

  var temperatureText: String {
    return forecastItemData.temperatureText
  }

  var weatherText: String {
    return forecastItemData.weatherText
  }

  var windSpeedText: String {
    return forecastItemData.windSpeedText
  }
  
  var windDirectionText: String {
    return forecastItemData.windDirectionText
  }

  var rainText: String {
    return forecastItemData.rainText ?? ""
  }
}

