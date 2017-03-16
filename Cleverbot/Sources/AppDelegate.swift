//
//  AppDelegate.swift
//  Cleverbot
//
//  Created by Suyeol Jeon on 01/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import CGFloatLiteral
import ManualLayout
import RxOptional
import SnapKit
import SwiftyColor
import SwiftyImage
import Then
import UITextView_Placeholder

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()

    let serviceProvider = ServiceProvider()
    let chatViewReactor = ChatViewReactor(provider: serviceProvider)
    let chatViewController = ChatViewController(reactor: chatViewReactor)
    let navigationController = UINavigationController(rootViewController: chatViewController)
    window.rootViewController = navigationController

    self.window = window
    return true
  }
}

