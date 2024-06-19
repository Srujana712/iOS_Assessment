//
//  SwiftUIMixView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import SwiftUI

// TODO: Create SwiftUI View that either pre-selects address or user enters address, and retrieves current weather plus weather forecast
struct SwiftUIView: View {
  // Modified and extended by Srujana
  @ObservedObject var viewModel: WeatherSummaryViewModel
  @State private var showAlert = false

  init(viewModel: WeatherSummaryViewModel) {
    self.viewModel = viewModel
  }

  fileprivate func currentWeatherView() -> some View {
    return VStack(alignment: .center, spacing: 5) {
      if let weather = viewModel.currentWeather {
        Text(weather.nameOfLocationText)
        Text(weather.currentWeatherText)
        Text(weather.temperatureText)
        Text(weather.windSpeedText)
        Text(weather.windDirectionText)
      } else {
        Text("No current data to display. Please search for a location.")
      }
    }
  }

  fileprivate func forecastWeatherView() -> some View {
    VStack(spacing: 10) {
      if !viewModel.forecastWeather.isEmpty {
        Text("5 Day Forecast")
          .font(.system(size: 20, weight: .bold))

        // This Scrollview can also be extracted into reusbale component that can take an array of Identifiable objects.
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(viewModel.forecastWeather, id: \.id) { dailyForecast in
              ForecastCardView(viewModel: ForecastCardViewModel(forecastItemData: dailyForecast))
                .frame(width: 200) // Adjust the width as needed
            }
          }
        }
      } else {
        Text("No forecast data to display. Please search for a location.")
      }
    }
  }

  var body: some View {
    ZStack {
      Color(.systemBackground)
        .edgesIgnoringSafeArea(.all)
      VStack {
        SearchBar(searchText: $viewModel.searchText, placeHolderText: "Search for a location")
          .onSubmit {
            viewModel.fecthWeatherForAddress()
          }
          .padding(.top, 10)
          .padding(.horizontal, 15)

        currentWeatherView()
          .padding(.vertical, 25)
        forecastWeatherView()
        Spacer()
      }
      .padding(.top, 15)
    }
    .onTapGesture {
      UIApplication.shared.endEditing()
    }
    .onChange(of: viewModel.errorMessage) { oldValue, newValue in
      if newValue != nil {
        showAlert = true
      }
    }
    .alert(isPresented: $showAlert, content: {
      Alert(title: Text("Error"),
            message: Text((viewModel.errorMessage ?? "" ) + ". Please check the address searched and try again."),
            dismissButton: .default(Text("OK")) {
        viewModel.errorMessage = nil
      })
    })
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIView(viewModel: WeatherSummaryViewModel())
  }
}
