//
//  LoginView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct LoginView: View {
  @ObservedObject private var vm = LoginViewModel()
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
          SecureField("Password", text: $vm.password)
          Button {
            vm.login()
          } label: {
            Text("Login")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)
          HStack {
            Text("Don't have an account?")
            Button { screen = .register } label: {
              Text("Register")
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
