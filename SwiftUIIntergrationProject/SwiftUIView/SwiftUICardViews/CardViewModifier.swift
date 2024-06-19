//
//  CardView.swift
//  SwiftUIIntergrationProject
//
//  Created by Srujana Eega on 6/16/24.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
  func body(content: Content) -> some View {
      content
          .padding()
          .background(Color(.secondarySystemBackground))
          .cornerRadius(10)
          .shadow(radius: 5)
  }
}

extension View {
  func card() -> some View {
    modifier(CardViewModifier())
  }
}

