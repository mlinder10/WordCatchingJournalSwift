//
//  ProtectedRootView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct ProtectedRootView: View {
  var body: some View {
    TabView {
      FeedView()
        .tabItem { Image(systemName: "newspaper") }
      PostView()
        .tabItem { Image(systemName: "plus") }
      SearchView()
        .tabItem { Image(systemName: "magnifyingglass") }
      AccountView()
        .tabItem { Image(systemName: "person") }
    }
  }
}

#Preview {
  ProtectedRootView()
}
