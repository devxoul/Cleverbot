//
//  Message.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ObjectMapper

enum Message {
  case incoming(IncomingMessage)
  case outgoing(OutgoingMessage)

  var text: String {
    switch self {
    case .incoming(let message):
      return message.text
    case .outgoing(let message):
      return message.text
    }
  }
}
