//
//  AccountView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct AccountView: View {
  @ObservedObject private var vm = AccountViewModel()
  private var user = NetworkManager.shared.user
  
  var body: some View {
    NavigationStack(path: $vm.path) {
      VStack {
        header
          .padding(.bottom)
        Divider()
        Spacer()
        posts
        Spacer()
      }
      .navigationDestination(for: String.self) { uid in
        UserView(uid, $vm.path)
      }
    }
  }
}

extension AccountView {
  private var header: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        VStack(alignment: .leading) {
          Text(user?.username ?? "")
            .font(.title2)
          Text(user?.email ?? "")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        Spacer()
        NavigationLink(destination: EditProfileView()) {
          HStack {
            Image(systemName: "slider.horizontal.3")
            Text("Edit Profile")
              .font(.footnote)
          }
        }
      }
      HStack {
        ProfileImage(uri: user?.profileImageUrl ?? "")
        Spacer()
        HStack(spacing: 24) {
          VStack {
            Text("Posts")
            Text("\(vm.posts.count)")
          }
          NavigationLink(destination: FollowView(.following, NetworkManager.shared.user!)) {
            VStack {
              Text("Following")
              Text("\(user?.following.count ?? 0)")
            }
          }
          NavigationLink(destination: FollowView(.followers, NetworkManager.shared.user!)) {
            VStack {
              Text("Followers")
              Text("\(user?.followers.count ?? 0)")
            }
          }
        }
        .font(.footnote)
        .foregroundStyle(.primary)
      }
    }
    .padding(.horizontal)
  }
  
  private var posts: some View {
    Group {
      switch (vm.postStatus) {
      case .complete:
        ScrollView {
          LazyVStack(spacing: 24) {
            ForEach(vm.posts, id: \.pid) { post in
              PostCell(path: $vm.path, uid: user?.uid ?? "", post: post)
            }
            .padding(.top)
          }
        }
      case .loading:
        ProgressView()
      case .error:
        Text("Error fetching Posts")
      case .empty:
        Text("No Posts")
      case .actionRequired:
        Text("")
      }
    }
  }
}

#Preview {
  AccountView()
}
