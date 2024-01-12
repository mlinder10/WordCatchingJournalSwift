//
//  RegisterView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct RegisterView: View {
  @ObservedObject private var vm = RegisterViewModel()
  @Binding var screen: Screen
  
  var body: some View {
    ZStack {
      VStack {
        Image("logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .offset(y: 60)
        Spacer()
      }
      VStack {
        Spacer()
        VStack(spacing: 16) {
          TextField("Email", text: $vm.email)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
          TextField("Username", text: $vm.username)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
          SecureField("Password", text: $vm.password)
          Button {
            vm.register()
          } label: {
            Text("Login")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)
          HStack {
            Text("Already have an account?")
            Button { screen = .login } label: {
              Text("Login")
            }
          }
          .font(.footnote)
        }
        
        .frame(maxWidth: 250)
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .fill(.thinMaterial)
        )
        .offset(y: -100)
      }
    }
  }
}
