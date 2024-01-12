//
//  AccountViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation

final class AccountViewModel: ObservableObject {
  @Published var path = [String]()
  @Published var posts = [Post]()
  @Published var postStatus: ServiceStatus = .loading
  
  init() {
    fetchPosts()
  }
  
  func fetchPosts() {
    postStatus = .loading
    Task {
      do {
        let posts = try await NetworkManager.shared.fetchPosts(NetworkManager.shared.user?.uid ?? "")
        await MainActor.run {
          self.posts = posts
          if posts.count == 0 {
            postStatus = .empty
          } else {
            postStatus = .complete
          }
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          postStatus = .error
        }
      }
    }
  }
}
