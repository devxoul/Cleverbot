//
//  MessageCellReactor.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class MessageCellReactor: Reactor {
  typealias Action = NoAction
  struct State {
    var message: String?
  }

  let initialState: State

  init(message: Message) {
    self.initialState = State(message: message.text)
  }
}
