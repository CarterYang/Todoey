//
//  AppDelegate.swift
//  Todoey
//
//  Created by Carter on 2018-12-06.
//  Copyright © 2018 Carter. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //在用户点开APP，发生在viewDidLoad之前
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //The location of the realm file
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //Initialize new realm
        do {
             _ = try Realm()
        }
        catch {
            print("Error initialising new realm, \(error)")
        }
        
        
        
        return true
    }
    
    //当操作界面被中断时发生，用来暂停任务，停止时间
    func applicationWillResignActive(_ application: UIApplication) {

    }

    //当App转入后台执行
    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    //当完全关掉App时执行
    func applicationWillTerminate(_ application: UIApplication) {

    }
    
}

