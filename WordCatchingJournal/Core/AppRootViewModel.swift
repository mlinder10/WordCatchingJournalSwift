//
//  AppRootViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

//import Foundation
//import SwiftUI
//
//final class AppRootViewModel: ObservableObject {
//  @AppStorage("wcj-user") var localUser: Data?
//  @Published var hasAttemptedLogin = false
//  
//  init() {
//    Task {
//      do {
//        guard let localUser else {
//          throw CancellationError()
//        }
//        let jsonUser = try JSONDecoder().decode(LocalUserData.self, from: localUser)
//        let user = try await NetworkManager.shared.login(jsonUser.email, jsonUser.password)
//        await MainActor.run {
//          NetworkManager.shared.user = user
//
//        }
//        await MainActor.run {
//          hasAttemptedLogin = true
//        }
//      } catch {
//        await MainActor.run {
//          hasAttemptedLogin = true
//        }
//      }
//    }
//  }
//}
//
//struct LocalUserData: Codable {
//  let email: String;
//  let password: String;
//}
