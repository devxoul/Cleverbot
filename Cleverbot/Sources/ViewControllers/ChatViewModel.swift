//
//  ChatViewModel.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ChatViewModelType {
  // Input
  var viewDidLoad: PublishSubject<Void> { get }
  var messageInputDidTapSendButton: PublishSubject<String> { get }

  // Output
  var sections: Driver<[ChatViewSection]> { get }
}


final class ChatViewModel: ChatViewModelType {

  // MARK: Types

  enum MessageOperation {
    case receive(Message)
    case send(Message)
  }


  // MARK: Input

  let viewDidLoad: PublishSubject<Void> = .init()
  let messageInputDidTapSendButton: PublishSubject<String> = .init()


  // MARK: Ouptut

  let sections: Driver<[ChatViewSection]>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    let dummyMessages: [Message] = [
      .outgoing(.init(text: "Hi")),
    ]
    let dummySectionItems = dummyMessages.map { message -> ChatViewSectionItem in
      let cellModel = MessageCellModel(provider: provider, message: message)
      switch message {
      case .incoming:
        return .incomingMessage(cellModel)
      case .outgoing:
        return .outgoingMessage(cellModel)
      }
    }
    let dummySections = [ChatViewSection(items: dummySectionItems)]
    self.sections = Driver.just(dummySections).debug("sections")
  }

}
