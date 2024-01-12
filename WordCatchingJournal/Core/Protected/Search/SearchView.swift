//
//  SearchView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct SearchView: View {
  @ObservedObject private var vm = SearchViewModel()
  private let gridItems = [
    GridItem(),
    GridItem(),
    GridItem()
  ]
  
  var body: some View {
    NavigationStack(path: $vm.path) {
      switch (vm.searchStatus) {
      case .complete:
        ScrollView {
          VStack {
            users
              .padding(.vertical)
            posts
          }
        }
        .navigationDestination(for: String.self) { uid in
          UserView(uid, $vm.path)
        }
      case .loading:
        ProgressView()
      case .error:
        Text("Error fetching search results")
      case .empty:
        Text("No results for \"\(vm.search)\"")
      case .actionRequired:
        Text("Enter a search")
      }
    }
    .searchable(text: $vm.search, prompt: "Search for posts and users")
  }
}

extension SearchView {
  private var users: some View {
    LazyVGrid(columns: gridItems) {
      ForEach(vm.users, id: \.uid) { user in
        UserCell(path: $vm.path, user: user, uid: NetworkManager.shared.user?.uid ?? "")
      }
    }
  }
  
  private var posts: some View {
    LazyVStack {
      ForEach(vm.posts, id: \.pid) { post in
        PostCell(path: $vm.path, uid: NetworkManager.shared.user?.uid ?? "", post: post)
          .padding(.vertical)
        Divider()
      }
    }
  }
}

#Preview {
  SearchView()
}
