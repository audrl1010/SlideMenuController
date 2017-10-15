//
//  AppDelegate.swift
//  SlideMenuController
//
//  Created by audrl1010 on 10/15/2017.
//  Copyright (c) 2017 audrl1010. All rights reserved.
//

import UIKit
import SlideMenuController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    UINavigationBar.appearance().barTintColor = UIColor(
      red: 255/255,
      green: 152/255,
      blue: 106/255,
      alpha: 1.0
    )
    
    let mainVC = MainViewController()
    let leftVC = LeftViewController()
    let rightVC = RightViewController()
    let mainVCNavC = UINavigationController(rootViewController: mainVC)
    
    let slideMenuController = SlideMenuController(
      mainViewController: mainVCNavC,
      leftViewController: leftVC,
      rightViewController: rightVC
    )
    slideMenuController.mainNavigationBarLeftToggleButtonIcon = #imageLiteral(resourceName: "toggle")
    
    window?.rootViewController = slideMenuController
    return true
  }

}

