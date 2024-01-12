//
//  FollowView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 12/2/23.
//

import SwiftUI

struct FollowView: View {
  @ObservedObject private var vm: FollowViewModel
  
  init(_ screen: FollowScreen, _ user: User) {
    self.vm = FollowViewModel(screen, user)
  }
  
  var body: some View {
    VStack {
      header
      list
    }
  }
}

extension FollowView {
  private var header: some View {
    HStack {
      Text(vm.user.username)
      Spacer()
      HStack {
        Button { vm.screen = .following } label: {
          Text("Following")
        }
        Button { vm.screen = .followers } label: {
          Text("Followers")
        }
      }
    }
  }
  
  private var list: some View {
    ScrollView {
      LazyVStack(spacing: 24) {
        ForEach(vm.screen == .followers ? vm.followers : vm.following, id: \.uid) { user in
          SearchUserCell(user: user)
        }
      }
    }
  }
}

struct SearchUserCell: View {
  let user: User
  
  var body: some View {
    HStack(spacing: 12) {
      ProfileImage(uri: user.profileImageUrl)
      Text(user.username)
    }
  }
}
