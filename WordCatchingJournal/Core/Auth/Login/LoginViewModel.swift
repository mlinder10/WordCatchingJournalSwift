//
//  LoginViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  
  func login() {
    Task {
      do {
        try await NetworkManager.shared.login(email, password)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
