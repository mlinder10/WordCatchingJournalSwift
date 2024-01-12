//
//  UserView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 12/2/23.
//

import SwiftUI

struct UserView: View {
  private let uid: String
  @Binding var path: [String]
  @ObservedObject private var vm: UserViewModel
  
  init(_ uid: String, _ path: Binding<[String]>) {
    self.uid = uid
    self._path = path
    self.vm = UserViewModel(uid)
  }
  
  var body: some View {
    if vm.userStatus == .loading {
      ProgressView()
    } else if vm.userStatus == .error {
      Text("Error fetching user")
    } else {
      VStack {
        header
          .padding(.top)
        posts
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button { vm.followUser() } label: {
            Text(((vm.user?.followers.contains(NetworkManager.shared.user?.uid ?? "")) ?? false) ? "Unfollow" : "Follow")
          }
        }
        ToolbarItem(placement: .principal) {
          Text(vm.user?.username ?? "")
            .font(.title2)
            .fontWeight(.bold)
        }
      }
    }
  }
}

extension UserView {
  private var header: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        ProfileImage(uri: vm.user?.profileImageUrl ?? "")
        Spacer()
        HStack(spacing: 24) {
          VStack {
            Text("Posts")
            Text("\(vm.posts.count)")
          }
          NavigationLink(destination: FollowView(.following, vm.user!)) {
            VStack {
              Text("Following")
              Text("\(vm.user?.following.count ?? 0)")
            }
          }
          NavigationLink(destination: FollowView(.followers, vm.user!)) {
            VStack {
              Text("Followers")
              Text("\(vm.user?.followers.count ?? 0)")
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
          LazyVStack {
            ForEach(vm.posts, id: \.pid) { post in
              PostCell(path: $path, uid: NetworkManager.shared.user?.uid ?? "", post: post)
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
