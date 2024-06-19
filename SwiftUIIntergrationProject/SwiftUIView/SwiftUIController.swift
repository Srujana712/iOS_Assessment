//
//  SwiftUIMixController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import UIKit
import SwiftUI

class SwiftUIController: UIViewController {
  override func viewDidLoad() {
    let weatherSummaryViewModel = WeatherSummaryViewModel()
    let swiftUIView = SwiftUIView(viewModel: weatherSummaryViewModel)
    let hosting = UIHostingController(rootView: swiftUIView)
    addChild(hosting)
    view.addSubview(hosting.view)
    hosting.view.snp.updateConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
