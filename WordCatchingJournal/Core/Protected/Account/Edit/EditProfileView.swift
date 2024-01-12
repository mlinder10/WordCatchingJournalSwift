//
//  EditProfileView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 12/2/23.
//

import SwiftUI

struct EditProfileView: View {
  @ObservedObject var vm = EditProfileViewModel()
  
  var body: some View {
    VStack {
      Text("")
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button { NetworkManager.shared.logout() } label: {
          HStack {
            Text("Logout")
            Image(systemName: "rectangle.portrait.and.arrow.right")
          }
        }
      }
    }
  }
}

#Preview {
    EditProfileView()
}
