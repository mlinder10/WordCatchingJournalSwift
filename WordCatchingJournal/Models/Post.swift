//
//  Post.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation

struct Post: Codable {
  init(from decoder: Decoder) throws {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [
        .withInternetDateTime,
        .withFractionalSeconds
    ]
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.pid = try container.decode(String.self, forKey: .pid)
    self.uid = try container.decode(String.self, forKey: .uid)
    self.word = try container.decode(String.self, forKey: .word)
    self.definition = try container.decode(String.self, forKey: .definition)
    self.email = try container.decode(String.self, forKey: .email)
    self.username = try container.decode(String.self, forKey: .username)
    self.profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
    self.createdAt = formatter.date(from: try container.decode(String.self, forKey: .createdAt))!
    self.likes = try container.decode([String].self, forKey: .likes)
  }
  
  let pid: String;
  let uid: String;
  let word: String;
  let definition: String;
  let email: String;
  let username: String;
  let profileImageUrl: String;
  let createdAt: Date;
  let likes: [String]
}
