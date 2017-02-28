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
  var viewDidDeallocate: PublishSubject<Void> { get }
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
  let viewDidDeallocate: PublishSubject<Void> = .init()
  let messageInputDidTapSendButton: PublishSubject<String> = .init()


  // MARK: Ouptut

  let sections: Driver<[ChatViewSection]>


  // MARK: Initializing

  init(provider: ServiceProviderType) {
    // please contribute! - I don't want to use Variables 😂
    let cleverbotState: Variable<String?> = .init(nil)

    let messageDidReceive: Observable<IncomingMessage> = self.messageInputDidTapSendButton
      .withLatestFrom(cleverbotState.asObservable()) { ($0, $1) }
      .flatMap { provider.cleverbotService.getReply(text: $0, cs: $1) }
      .shareReplay(1)

    _ = messageDidReceive
      .map { $0.cs }
      .takeUntil(self.viewDidDeallocate)
      .bindTo(cleverbotState)

    let mesageOperationReceive: Observable<MessageOperation> = messageDidReceive
      .map { MessageOperation.receive(.incoming($0)) }
      .shareReplay(1)

    let mesageOperationSend: Observable<MessageOperation> = self.messageInputDidTapSendButton
      .map { text -> MessageOperation in
        let outgoingMessage = OutgoingMessage(text: text)
        let message = Message.outgoing(outgoingMessage)
        return MessageOperation.send(message)
      }
      .shareReplay(1)

    let messages: Observable<[Message]> = Observable
      .of(mesageOperationReceive, mesageOperationSend)
      .merge()
      .scan([]) { messages, operation in
        switch operation {
        case .receive(let newMessage):
          return messages + [newMessage]

        case .send(let newMessage):
          return messages + [newMessage]
        }
      }
      .shareReplay(1)

    let messageSection: Observable<[ChatViewSection]> = messages
      .map { messages in
        let sectionItems = messages.map { message -> ChatViewSectionItem in
          let cellModel = MessageCellModel(provider: provider, message: message)
          switch message {
          case .incoming:
            return ChatViewSectionItem.incomingMessage(cellModel)
          case .outgoing:
            return ChatViewSectionItem.outgoingMessage(cellModel)
          }
        }
        return [ChatViewSection(items: sectionItems)]
      }
      .shareReplay(1)

    self.sections = messageSection.asDriver(onErrorJustReturn: [])
  }

}
