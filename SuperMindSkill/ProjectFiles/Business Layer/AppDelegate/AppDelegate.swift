//
//  AppDelegate.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   
    var userCurrentSubsCription: enEnableType?
    lazy var operationQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        queue.name = "ServerInteractionQueue"
        queue.qualityOfService = .background
        return queue
    }()
    static var kQueueOperationsChanged = "kQueueOperationsChanged"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        InAppPurchaseClass.share.fetchProducts()
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true

        self.operationQueue.addObserver(self, forKeyPath: "operations", options: NSKeyValueObservingOptions(rawValue: 0), context: &AppDelegate.kQueueOperationsChanged)
        
        
       ///Chakeck User ALready logged in or Not
        if let userID:String = UserDefaults.standard.value(forKey: "USERID") as? String {
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let model = ModelInAppPurchase()
            model.detailsOfInAppPurchase(userID: userID) { (status, message) in
                DispatchQueue.main.async {
                    let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
                    
                    if status == enPurchaseType.logeIn.rawValue {
                        profileViewController.userCurrentSubsCription = .NoMembership
                        self.userCurrentSubsCription = .NoMembership
                        
                    }else if  (status == enPurchaseType.trial.rawValue) || (status == enPurchaseType.membership.rawValue){
                        profileViewController.userCurrentSubsCription = .OnMmbership
                        self.userCurrentSubsCription = .OnMmbership
                    } else if (status == enPurchaseType.trialExpire.rawValue) || (status == enPurchaseType.membershipExpire.rawValue){
                        profileViewController.userCurrentSubsCription = .Expire
                        self.userCurrentSubsCription = .Expire
                    }
                    rootViewController.pushViewController(profileViewController, animated: true)
                }
                
            }
    
                 
              }
              else {
                  let rootViewController = self.window!.rootViewController as! UINavigationController
                  let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                  let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                  rootViewController.pushViewController(profileViewController, animated: true)
              }
        // In app purchase
        //self.inApp  = InAppPurchaseClass()
       // self.inApp?.fetchProducts()
        
        return true
    }
    
  
    // MARK: - NAVIGATION
    internal func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        
        if (rootViewController == nil) { return nil }
        
        if (rootViewController.isKind(of: (UITabBarController).self)) {
            
            
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
            
        } else if (rootViewController.isKind(of:(UINavigationController).self)) {
            
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
            
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SuperMindSkill")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension AppDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (((object as? OperationQueue) === self.operationQueue) && (keyPath == "operations") && (context == &AppDelegate.kQueueOperationsChanged)) {
            DispatchQueue.main.async {
                if self.operationQueue.operationCount > 0 {
                   CustomActivityIndicator.sharedInstance.display(onView: UIApplication.shared.keyWindow, done: {
                        
                    })
                    
                }else{
                    CustomActivityIndicator.sharedInstance.hide {
                        
                    }
                }
                
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
