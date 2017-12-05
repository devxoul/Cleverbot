//
//  IncomingMessageCell.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

final class IncomingMessageCell: BaseMessageCell {

  // MARK: Constants

  fileprivate struct Color {
    static let bubbleViewBackground = 0xD9D9D9.color
    static let messageLabelText = UIColor.black
  }


  // MARK: Initializing

  @objc init(frame: CGRect) {
    let appearance = Appearance(
      bubbleViewBackgroundColor: Color.bubbleViewBackground,
      bubbleViewAlignment: .left,
      messageLabelTextColor: Color.messageLabelText
    )
    super.init(frame: frame, appearance: appearance)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
