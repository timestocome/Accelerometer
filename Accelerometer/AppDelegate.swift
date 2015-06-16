//
//  AppDelegate.swift
//  Accelerometer
//
//  Created by Linda Cobb on 10/16/14.
//  Copyright (c) 2014 TimesToCome Mobile. All rights reserved.
//

import UIKit
import CoreMotion


@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let sharedManager: CMMotionManager = CMMotionManager()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {}

    func applicationWillTerminate(application: UIApplication) {}


}

