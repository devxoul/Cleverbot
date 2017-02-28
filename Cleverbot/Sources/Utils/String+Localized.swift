//
//  String+Localized.swift
//  Zeta
//
//  Created by Suyeol Jeon on 16/02/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}
