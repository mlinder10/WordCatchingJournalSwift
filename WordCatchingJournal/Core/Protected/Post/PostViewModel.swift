//
//  PostViewModel.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation
import Combine

enum PostScreens {
  case definitions, custom
}

final class PostViewModel: ObservableObject {
  @Published var wordInput = ""
  @Published var definitionInput = ""
  @Published var definitions = [Definition]()
  @Published var definitionStatus: ServiceStatus = .actionRequired
  @Published var postStatus: ServiceStatus = .actionRequired
  @Published var screen: PostScreens = .definitions
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    $wordInput
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .sink(receiveValue: { [weak self] word in
        self?.fetchDefinitions(word)
      })
      .store(in: &subscriptions)
  }
  
  func fetchDefinitions(_ word: String) {
    if word == "" {
      definitionStatus = .actionRequired
      return
    }
    definitionStatus = .loading
    Task {
      do {
        let definitions = try await NetworkManager.shared.fetchDefinitions(word)
        await MainActor.run {
          self.definitions = definitions
          if definitions.count == 0 {
            definitionStatus = .empty
          } else {
            definitionStatus = .complete
          }
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          definitionStatus = .error
        }
      }
    }
  }
  
  func post() {
    if wordInput == "" || definitionInput == "" {
      postStatus = .actionRequired
      return
    }
    postStatus = .loading
    Task {
      do {
        let _ = try await NetworkManager.shared.post(wordInput, definitionInput)
        await MainActor.run {
          postStatus = .complete
        }
      } catch {
        print(error.localizedDescription)
        await MainActor.run {
          postStatus = .error
        }
      }
    }
  }
}
