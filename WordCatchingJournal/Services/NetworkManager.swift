//
//  NetworkManager.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation
import SwiftUI

final class NetworkManager: ObservableObject {
  static var shared = NetworkManager()
  @AppStorage("wcj-user") private var localUser: Data?
  @Published var user: User?
  @Published var hasAttemptedLogin = false
  let baseUrl = "https://word-catching-journal.vercel.app/api/"
  let apiKey = ""
  let apiField = "Authorization"
  
  struct LocalUserData: Codable {
    let email: String;
    let password: String;
  }
  
  init() {
    Task {
      do {
        guard let localUser else {
          hasAttemptedLogin = true
          return
        }
        let jsonUser = try JSONDecoder().decode(LocalUserData.self, from: localUser)
        try await login(jsonUser.email, jsonUser.password)
        await MainActor.run {
          hasAttemptedLogin = true
        }
      } catch {
        await MainActor.run {
          hasAttemptedLogin = true
        }
      }
    }
  }
  
  func logout() {
    user = nil
    localUser = nil
  }
}

//auth
extension NetworkManager {
  func login(_ email: String, _ password: String) async throws {
    guard let url = URL(string: "\(baseUrl)auth/") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    request.setValue(email, forHTTPHeaderField: "email")
    request.setValue(password, forHTTPHeaderField: "password")
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      try await MainActor.run {
        user = try JSONDecoder().decode(User.self, from: data)
        localUser = try JSONEncoder().encode(LocalUserData(email: email, password: password))
      }
    } catch {
      throw URLError(.badServerResponse)
    }
  }
  
  func register(_ email: String, _ username: String, _ password: String) async throws {
    guard let url = URL(string: "\(baseUrl)auth/") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    let body = ["email": email, "username": username, "password": password]
    
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: body)
    } catch {
      throw URLError(.requestBodyStreamExhausted)
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      try await MainActor.run {
        user = try JSONDecoder().decode(User.self, from: data)
        localUser = try JSONEncoder().encode(LocalUserData(email: email, password: password))
      }
    } catch {
      throw URLError(.badServerResponse)
    }
  }
}

// feed
extension NetworkManager {
  func fetchRecentPosts() async throws -> [Post] {
    guard let url = URL(string: "\(baseUrl)feed/recent") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode([Post].self, from: data)
      return res
    } catch {
      throw URLError(.badServerResponse)
    }
  }
  
  func fetchFollowingPosts() async throws -> [Post] {
    guard let user else { throw URLError(.badURL) }
    guard let url = URL(string: "\(baseUrl)feed/following") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    request.setValue(user.uid, forHTTPHeaderField: "uid")
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode([Post].self, from: data)
      return res
    } catch {
      throw URLError(.badServerResponse)
    }
  }
}

// follow
extension NetworkManager {
  func fetchFollow(_ uid: String) async throws -> GetFollowResponse {
    guard let url = URL(string: "\(baseUrl)follow/") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    request.setValue(uid, forHTTPHeaderField: "uid")
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode(GetFollowResponse.self, from: data)
      return res
    } catch {
      throw URLError(.badServerResponse)
    }
  }
  
  func followUser(pageUser: User) async throws -> User {
    guard let url = URL(string: "\(baseUrl)follow/") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    let body = ["user": user, "pageUser": pageUser]
    
    do {
      request.httpBody = try JSONEncoder().encode(body)
    } catch {
      throw URLError(.requestBodyStreamExhausted)
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode(PatchFollowResponse.self, from: data)
      await MainActor.run {
        user = res.user
      }
      return res.pageUser 
    } catch {
      throw URLError(.badServerResponse)
    }
  }
}

// like
extension NetworkManager {
  func likePost(_ pid: String) async throws -> Post {
    guard let user else { throw URLError(.badURL) }
    guard let url = URL(string: "\(baseUrl)like/") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    let body = ["pid": pid, "uid": user.uid]
    
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: body)
    } catch {
      throw URLError(.requestBodyStreamExhausted)
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode(Post.self, from: data)
      return res
    } catch {
      throw URLError(.badServerResponse)
    }
  }
}

// post
extension NetworkManager {
  func fetchDefinitions(_ word: String) async throws -> [Definition] {
    guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else {
      throw URLError(.badURL)
    }
    
    let request = URLRequest(url: url)
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode([DefinitionResponse].self, from: data)
      return Definition.parseFetchedDefinitions(res)
    } catch {
      throw URLError(.badServerResponse)
    }
  }
  
  func post(_ word: String, _ definition: String) async throws -> Post {
    guard let url = URL(string: "\(baseUrl)post/") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    let body = ["word": word, "definition": definition, "user": user ?? ""] as [String : Any]
    
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: body)
    } catch {
      throw URLError(.requestBodyStreamExhausted)
    }
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode(Post.self, from: data)
      return res
    } catch {
      throw URLError(.badServerResponse)
    }
  }
}

// posts
extension NetworkManager {
  func fetchPosts(_ uid: String) async throws -> [Post] {
    guard let url = URL(string: "\(baseUrl)posts?uid=\(uid)") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode([Post].self, from: data)
      return res
    } catch {
      throw URLError(.badServerResponse)
    }
  }
}

// search
extension NetworkManager {
  func fetchSearch(_ search: String) async throws -> GetSearchResponse {
    guard let url = URL(string: "\(baseUrl)search?search=\(search)") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode(GetSearchResponse.self, from: data)
      return res
    } catch {
      throw URLError(.badServerResponse)
    }
  }
}

// user
extension NetworkManager {
  func fetchUser(_ uid: String) async throws -> User {
    guard let url = URL(string: "\(baseUrl)user/") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.setValue(apiKey, forHTTPHeaderField: apiField)
    request.setValue(uid, forHTTPHeaderField: "uid")
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let res = try JSONDecoder().decode(User.self, from: data)
      return res
    } catch {
      throw URLError(.badServerResponse)
    }
  }
}
