//
//  FeedViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation
import SwiftUI

enum FeedScreen {
  case recent, following
}

final class FeedViewModel: ObservableObject {
  @Published var path = [String]()
  @Published var posts = [Post]()
  @Published var screen: FeedScreen = .recent {
    didSet {
      fetchPosts()
    }
  }
  
  init() {
    fetchPosts()
  }
  
  func fetchPosts() {
    Task {
      do {
        if screen == .recent {
          let posts = try await NetworkManager.shared.fetchRecentPosts()
          await MainActor.run {
            self.posts = posts
          }
        } else {
          let posts = try await NetworkManager.shared.fetchFollowingPosts()
          await MainActor.run {
            self.posts = posts
          }
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
