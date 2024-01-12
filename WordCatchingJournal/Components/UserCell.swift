//
//  UserCell.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct UserCell: View {
  @Binding var path: [String]
  let user: User
  let uid: String
  
  private func navigate() {
    if user.uid == path.last { return }
    if user.uid == uid { return }
    path.append(user.uid)
  }
  
  var body: some View {
    Button { navigate() } label: {
      VStack {
        ProfileImage(uri: user.profileImageUrl)
        Text(user.username)
      }
    }
  }
}
