//
//  BaseService.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

class BaseService {
  unowned let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }
}
