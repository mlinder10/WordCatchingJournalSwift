//
//  FeedView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct FeedView: View {
  @ObservedObject private var vm = FeedViewModel()
  
  var body: some View {
    NavigationStack(path: $vm.path) {
      VStack {
        header
        Divider()
        posts
      }
      .navigationDestination(for: String.self) { uid in
        UserView(uid, $vm.path)
      }
      .navigationDestination(for: Int.self) { _ in
        AccountView()
      }
    }
  }
}

extension FeedView {
  private var header: some View {
    VStack(spacing: 24) {
      Image("logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 60, height: 60)
      HStack {
        Button {
          vm.screen = .recent
        } label: {
          Text("Recent")
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .foregroundStyle(vm.screen == .recent ? .accent : .secondary)
        }
        Button {
          vm.screen = .following
        } label: {
          Text("Following")
            .frame(maxWidth: .infinity)
            .foregroundStyle(vm.screen == .following ? .accent : .secondary)
        }
      }
    }
  }
  
  private var posts: some View {
    ScrollView {
      LazyVStack(spacing: 24) {
        ForEach(vm.posts, id: \.pid) { post in
          PostCell(path: $vm.path, uid: NetworkManager.shared.user?.uid ?? "", post: post)
          Divider()
        }
      }
    }
  }
}

#Preview {
  FeedView()
}
