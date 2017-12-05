//
//  IncomingMessage.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

/// The message from cleverbot
struct IncomingMessage: ModelType {
  var cs: String
  var text: String

  enum CodingKeys: String, CodingKey {
    case cs
    case text = "output"
  }
}
