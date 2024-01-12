//
//  RegisterViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation
import SwiftUI

final class RegisterViewModel: ObservableObject {
  @Published var email = ""
  @Published var username = ""
  @Published var password = ""
  
  func register() {
    Task {
      do {
        try await NetworkManager.shared.register(email, username, password)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
