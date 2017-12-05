//
//  Message.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

enum Message {
  case incoming(IncomingMessage)
  case outgoing(OutgoingMessage)

  var text: String {
    switch self {
    case let .incoming(message):
      return message.text
    case let .outgoing(message):
      return message.text
    }
  }
}
