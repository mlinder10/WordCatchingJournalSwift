//
//  AppRootView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct AppRootView: View {
  @ObservedObject var manager = NetworkManager.shared
  
  var body: some View {
    if !manager.hasAttemptedLogin {
      ProgressView()
    } else {
      if manager.user == nil {
        AuthRootView()
      } else {
        ProtectedRootView()
      }
    }
  }
}

#Preview {
  AppRootView()
}
