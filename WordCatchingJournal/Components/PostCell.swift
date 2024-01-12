//
//  PostCell.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct PostCell: View {
  @Binding var path: [String]
  let uid: String
  let post: Post
  
  private func navigate() {
    if post.uid == path.last { return }
    if post.uid == uid { return }
    path.append(post.uid)
  }
  
  private func like() {}
  
  var body: some View {
    HStack(alignment: .top, spacing: 20) {
      Button { navigate() } label: {
        ProfileImage(uri: post.profileImageUrl, size: 25)
      }
      .foregroundStyle(.primary)
      VStack(alignment: .leading, spacing: 12) {
        Text(post.word.capitalized)
          .fontWeight(.semibold)
          .font(.title3)
        Text(post.definition)
        HStack(spacing: 8) {
          Button { like() } label: {
            HStack(spacing: 2) {
              Image(systemName: post.likes.contains(uid) ? "heart.fill" : "heart")
                .foregroundStyle(post.likes.contains(uid) ? .red : .secondary)
              Text(post.likes.count == 1 ? "\(post.likes.count) Like" : "\(post.likes.count) Likes")
            }
          }
          Button { navigate() } label: {
            Text(post.username)
          }
          Text(post.createdAt.formatted(date: .abbreviated, time: .shortened))
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
      }
      Spacer()
    }
    .padding(.horizontal)
  }
}
