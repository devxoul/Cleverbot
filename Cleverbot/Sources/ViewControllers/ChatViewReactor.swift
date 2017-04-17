//
//  ChatViewReactor.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class ChatViewReactor: Reactor {

  enum Action {
    case send(String)
  }

  enum Mutation {
    case addMessage(Message)
  }

  struct State {
    var sections: [ChatViewSection] = [ChatViewSection(items: [])]
    var cleverbotState: String? = nil
  }

  fileprivate let provider: ServiceProviderType
  let initialState = State()

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .send(text):
      let outgoingMessage = Observable.just(Message.outgoing(.init(text: text)))
      let incomingMessage = self.provider.cleverbotService
        .getReply(text: text, cs: self.currentState.cleverbotState)
        .map { incomingMessage in Message.incoming(incomingMessage) }
      return Observable.of(outgoingMessage, incomingMessage).merge()
        .map { message in Mutation.addMessage(message) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .addMessage(message):
      let reactor = MessageCellReactor(provider: self.provider, message: message)
      let sectionItem: ChatViewSectionItem
      switch message {
      case .incoming:
        sectionItem = .incomingMessage(reactor)
      case .outgoing:
        sectionItem = .outgoingMessage(reactor)
      }
      state.sections[0].items.append(sectionItem)
      return state
    }
  }

}
