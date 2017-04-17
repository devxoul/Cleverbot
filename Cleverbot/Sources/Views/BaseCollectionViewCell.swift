//
//  BaseCollectionViewCell.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {

  // MARK: Properties

  var disposeBag: DisposeBag = DisposeBag()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init(frame: .zero)
  }

}
