//
//  SearchViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
  @Published var path = [String]()
  @Published var search = ""
  @Published var users = [User]()
  @Published var posts = [Post]()
  @Published var searchStatus: ServiceStatus = .actionRequired
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    $search
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .sink(receiveValue: { [weak self] search in
        self?.fetchSearch(search)
      })
      .store(in: &subscriptions)
  }
  
  func fetchSearch(_ search: String) {
    if search == "" {
      searchStatus = .actionRequired
      return
    }
    searchStatus = .loading
    Task {
      do {
        let response = try await NetworkManager.shared.fetchSearch(search)
        await MainActor.run {
          users = response.users
          posts = response.posts
          if users.count == 0 && posts.count == 0 {
            searchStatus = .empty
          } else {
            searchStatus = .complete
          }
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          searchStatus = .error
        }
      }
    }
  }
}
