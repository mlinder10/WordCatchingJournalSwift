//
//  FollowViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 12/2/23.
//

import Foundation

enum FollowScreen {
  case following, followers
}

final class FollowViewModel: ObservableObject {
  @Published var screen: FollowScreen
  @Published var user: User
  @Published var followers = [User]()
  @Published var following = [User]()
  @Published var requestStatus: ServiceStatus = .loading
  
  init(_ screen: FollowScreen, _ user: User) {
    self.screen = screen
    self.user = user
    fetchUsers(user.uid)
  }
  
  func fetchUsers(_ uid: String) {
    requestStatus = .loading
    Task {
      do {
        let res = try await NetworkManager.shared.fetchFollow(uid)
        await MainActor.run {
          followers = res.followers
          following = res.following
          requestStatus = .complete
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          requestStatus = .error
        }
      }
    }
  }
}
