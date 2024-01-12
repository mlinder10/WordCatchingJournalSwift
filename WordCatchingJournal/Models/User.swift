//
//  User.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation

class User: Codable {  
  let uid: String;
  let email: String;
  var username: String;
  var password: String;
  var followers: [String];
  var following: [String];
  var profileImageUrl: String;
}
