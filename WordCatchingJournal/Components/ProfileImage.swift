//
//  ProfileImage.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct ProfileImage: View {
  let uri: String
  let size: CGFloat
  
  init(uri: String, size: CGFloat = 40) {
    self.uri = uri
    self.size = size
  }
  
  var body: some View {
    if uri == "" {
      Image(systemName: "person.circle")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: size, height: size)
    } else {
      AsyncImage(url: URL(string: uri)) { image in
        image
          .resizable()
          .frame(width: size, height: size)
          .clipShape(Circle())
      } placeholder: {
        Image(systemName: "person.circle")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: size, height: size)
      }
    }
  }
}
