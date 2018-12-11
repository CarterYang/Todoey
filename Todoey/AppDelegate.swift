//
//  AppDelegate.swift
//  Todoey
//
//  Created by Carter on 2018-12-06.
//  Copyright © 2018 Carter. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //在用户点开APP，发生在viewDidLoad之前
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Print out the path of UserDefauls file
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
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

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    //Lazy: only load up the value at the time point when it needed
    //"NSPersistentContainer" is where to store all the data, it's a SQLite database
    lazy var persistentContainer: NSPersistentContainer = {

        //Give a name of the database, in this case we call it "DataModel"
        let container = NSPersistentContainer(name: "DataModel")
        //Load up the PersistentStore
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            //See if there is any error
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    //"context" is an temp area you can change or update the data untill you are happy with the data
    //Then save the updated data from "context"
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

