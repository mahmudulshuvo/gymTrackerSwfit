//
//  Delegate.swift
//  gymTracker
//
//  Created by Shuvo on 9/19/18.
//  Copyright © 2018 Third Bit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var utility: Utility!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print("Database path: ", Utility.sharedInstance.databasePath)
        self.utility = Utility.sharedInstance
        
        self.utility.databaseName = "gymTracker.db"
        var documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        self.utility.documentDir = documentPaths[0]
       // utility.databasePath = URL(fileURLWithPath: utility.documentDir).appendingPathComponent(utility.databaseName).absoluteString
        self.utility.databasePath = self.utility.documentDir+"/"+utility.databaseName
        
        print(utility.databasePath)
        createAndCheckDatabase()
        
        //self.utility.settings = FMDBDataAccess.getSettings()
        self.utility.settings = FMDBDataAccessSwift.getSettings()
        self.utility.equipmentsList = FMDBDataAccess.getEquipments()
        self.utility.measurementsList = FMDBDataAccess.getMeasurements()
        
        return true
    }
    
    func createAndCheckDatabase() {
        var success: Bool
        
        let fileManager = FileManager.default
        success = fileManager.fileExists(atPath: utility.databasePath)
        
        if success {
            return
        }
        
        let databasePathFromApp = URL(fileURLWithPath: Bundle.main.resourcePath ?? "").appendingPathComponent(self.utility.databaseName).absoluteString
        
        try? fileManager.copyItem(atPath: databasePathFromApp, toPath: self.utility.databasePath)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

