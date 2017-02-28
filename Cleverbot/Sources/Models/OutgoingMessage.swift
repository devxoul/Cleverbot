//
//  OutgoingMessage.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ObjectMapper

struct OutgoingMessage {
  var text: String

  init(text: String) {
    self.text = text
  }
}
