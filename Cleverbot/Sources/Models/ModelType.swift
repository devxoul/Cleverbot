//
//  ModelType.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Then

/// Every model types should conform to this protocol.
protocol ModelType: Decodable, Then {
  static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
  static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
    return .iso8601
  }

  static var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = self.dateDecodingStrategy
    return decoder
  }

  init(data: Data) throws {
    self = try Self.decoder.decode(Self.self, from: data)
  }
}
