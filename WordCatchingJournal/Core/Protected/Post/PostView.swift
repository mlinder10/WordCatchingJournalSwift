//
//  PostView.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import SwiftUI

struct PostView: View {
  @ObservedObject private var vm = PostViewModel()
  
  var body: some View {
    NavigationStack {
      Group {
        if vm.screen == .definitions {
          definitions
        } else {
          custom
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            if vm.screen == .definitions {
              vm.screen = .custom
            } else {
              vm.screen = .definitions
            }
          } label: {
            Text(vm.screen == .definitions ? "Custom" : "Search")
          }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            vm.post()
          } label: {
            HStack {
              Text("Post")
              Image(systemName: "arrow.forward")
            }
          }
        }
      }
    }
    .searchable(text: $vm.wordInput, prompt: vm.screen == .definitions ? "Find a word's definition" : "Enter a word")
  }
}

extension PostView {
  private var definitions: some View {
    List {
      ForEach(vm.definitions, id: \.definition) { def in
        HStack(alignment: .top, spacing: 24) {
          Text(def.definition)
            .foregroundStyle(vm.definitionInput == def.definition ? .accent : .primary)
          Spacer()
          Text(def.partOfSpeech)
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .onTapGesture {
          vm.definitionInput = def.definition
        }
      }
    }
    .listStyle(.plain)
  }
  
  private var custom: some View {
    VStack {
      TextField("Enter your own definition...", text: $vm.definitionInput)
        .padding()
      Spacer()
    }
  }
}

#Preview {
  PostView()
}
