//
//  ModelType.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ObjectMapper
import Then

/// Every model types should conform to this protocol.
protocol ModelType: ImmutableMappable, Then {
}
