//
//  CompositionRoot.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 05/12/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

struct AppDependency {
  let window: UIWindow
}

enum CompositionRoot {
  static func resolve() -> AppDependency {
    // service
    let cleverbotService = CleverbotService()

    // root view controller
    let chatViewReactor = ChatViewReactor(cleverbotService: cleverbotService)
    let chatViewController = ChatViewController(reactor: chatViewReactor)
    let navigationController = UINavigationController(rootViewController: chatViewController)
    navigationController.navigationBar.prefersLargeTitles = true

    // window
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    return AppDependency(window: window)
  }
}
