//
//  ServiceProvider.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

protocol ServiceProviderType: class {
  var cleverbotService: CleverbotServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var cleverbotService: CleverbotServiceType = CleverbotService(provider: self)
}
