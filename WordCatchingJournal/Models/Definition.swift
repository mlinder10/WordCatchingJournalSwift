//
//  Definition.swift
//  WordCatchingJournal
//
//  Created by Matt Linder on 11/29/23.
//

import Foundation

struct Definition: Codable {
  let word: String;
  let definition: String;
  let example: String?;
  let synonyms: [String];
  let antonyms: [String]
  let origin: String?;
  let partOfSpeech: String;
  
  static func parseFetchedDefinitions(_ defs: [DefinitionResponse]) -> [Definition] {
    var parsedDefs = [Definition]()
    for def in defs {
      for meaning in def.meanings {
        for definition in meaning.definitions {
          parsedDefs.append(Definition(word: def.word,
                                       definition: definition.definition,
                                       example: definition.example,
                                       synonyms: definition.synonyms,
                                       antonyms: definition.antonyms,
                                       origin: def.origin,
                                       partOfSpeech: meaning.partOfSpeech))
        }
      }
    }
    return parsedDefs
  }
}
