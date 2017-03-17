//
//  MessageCellReactor.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol MessageCellReactorType {
  var messageLabelText: String? { get }
}

final class MessageCellReactor: MessageCellReactorType {

  // MARK: Output

  let messageLabelText: String?


  // MARK: Initializing

  init(provider: ServiceProviderType, message: Message) {
    self.messageLabelText = message.text
  }

}
