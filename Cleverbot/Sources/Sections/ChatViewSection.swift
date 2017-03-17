//
//  ChatViewSection.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxDataSources

struct ChatViewSection {
  var items: [ChatViewSectionItem]

  init(items: [ChatViewSectionItem]) {
    self.items = items
  }
}

extension ChatViewSection: SectionModelType {
  init(original: ChatViewSection, items: [ChatViewSectionItem]) {
    self = original
    self.items = items
  }
}

enum ChatViewSectionItem {
  case incomingMessage(MessageCellReactorType)
  case outgoingMessage(MessageCellReactorType)
}
