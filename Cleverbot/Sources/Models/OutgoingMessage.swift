//
//  OutgoingMessage.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

struct OutgoingMessage: ModelType {
  var text: String

  init(text: String) {
    self.text = text
  }
}
