//
//  ForecastCardView.swift
//  SwiftUIIntergrationProject
//
//  Created by Srujana Eega on 6/16/24.
//

import SwiftUI

struct ForecastCardView: View {
  var viewModel: ForecastCardViewModel

  var body: some View {
    VStack(alignment: .leading) {

      Text(viewModel.dateTimeText)
        .font(.headline)
        .padding([.top, .bottom], 5)

      VStack(alignment: .leading, spacing: 5) {
        Text(viewModel.temperatureText)
        Text(viewModel.weatherText)
        Text(viewModel.windSpeedText)
        Text(viewModel.windDirectionText)
        Text(viewModel.rainText)
      }
      .lineLimit(2)
      .fixedSize(horizontal: false, vertical: true)
      .padding(.bottom, 5)
      Spacer(minLength: 0).fixedSize(horizontal: true, vertical: false)
    }
    .card()
    .frame(height: 250) // Adjust the height as needed
    .padding([.top, .bottom], 5)
  }
}

struct ForecastCardView_Previews: PreviewProvider {
  static var previews: some View {
    let sampleForecast = ForecastItemDisplayData(id: "123",
                                                 timeDateText: "6/17/24, 5:00 PM",
                                                 temperatureText: "Temperaature: 92F",
                                                 weatherText: "Weather: Broken Clouds",
                                                 windSpeedText: "Wind: 13 mph",
                                                 windDirectionText: "Wind direction: Southeast",
                                                 rainText: "Rain: 0 inches")

    let viewModel = ForecastCardViewModel(forecastItemData: sampleForecast)

    return ForecastCardView(viewModel: viewModel)
      .previewLayout(.sizeThatFits)
      .padding()
  }
}

