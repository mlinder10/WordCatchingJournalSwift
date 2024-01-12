//
//  Responses.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation

struct GetFollowResponse: Codable {
  let following: [User];
  let followers: [User];
}

struct PatchFollowResponse: Codable {
  let user: User;
  let pageUser: User;
}

struct GetSearchResponse: Codable {
  let posts: [Post];
  let users: [User];
}

struct DefinitionResponse: Codable {
  let word: String;
  let phonetic: String;
  let origin: String?;
  let meanings: [Meaning];
  
  struct Meaning: Codable {
    let partOfSpeech: String;
    let definitions: [Def]
    
    struct Def: Codable {
      let definition: String;
      let example: String?;
      let synonyms: [String];
      let antonyms: [String];
    }
  }
}

enum ServiceStatus {
  case loading, error, empty, complete, actionRequired
}
