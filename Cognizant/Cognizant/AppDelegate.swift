//
//  AppDelegate.swift
//  Cognizant
//
//  Created by Richard Kim on 10/8/16.
//  Copyright © 2016 Richard Kim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let viewController = ViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.setToolbarHidden(false, animated: false)

        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        
        return true
    }
    
}

