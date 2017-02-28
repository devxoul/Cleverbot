//
//  IncomingMessage.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ObjectMapper

/// The message from cleverbot
struct IncomingMessage: ModelType {
  var cs: String
  var text: String

  init(map: Map) throws {
    self.cs = try map.value("cs")
    self.text = try map.value("output")
  }
}
