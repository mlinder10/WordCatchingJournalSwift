//
//  AuthRootView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

enum Screen {
  case login, register
}

struct AuthRootView: View {
  @State private var screen: Screen = .login
  var body: some View {
    if screen == .login {
      LoginView(screen: $screen)
    } else {
      RegisterView(screen: $screen)
    }
  }
}

#Preview {
    AuthRootView()
}
