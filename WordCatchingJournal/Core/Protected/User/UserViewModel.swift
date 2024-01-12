//
//  UserViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 12/2/23.
//

import Foundation

final class UserViewModel: ObservableObject {
  @Published var user: User? = nil
  @Published var posts = [Post]()
  @Published var userStatus: ServiceStatus = .loading
  @Published var postStatus: ServiceStatus = .loading
  
  init(_ uid: String) {
    fetchUser(uid)
    fetchPosts(uid)
  }
  
  func fetchUser(_ uid: String) {
    Task {
      do {
        let user = try await NetworkManager.shared.fetchUser(uid)
        await MainActor.run {
          self.user = user
          userStatus = .complete
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          userStatus = .error
        }
      }
    }
  }
  
  func fetchPosts(_ uid: String) {
    Task {
      do {
        let posts = try await NetworkManager.shared.fetchPosts(uid)
        await MainActor.run {
          self.posts = posts
          postStatus = .complete
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          postStatus = .error
        }
      }
    }
  }
  
  func followUser() {
    guard let user else {
      return
    }
    Task {
      do {
        let user = try await NetworkManager.shared.followUser(pageUser: user)
        await MainActor.run {
          self.user = user
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
