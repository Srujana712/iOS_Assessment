//
//  DismissKeyboard.swift
//  SwiftUIIntergrationProject
//
//  Created by Srujana Eega on 6/17/24.
//

import UIKit

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
