//
//  AppDelegate.swift
//  MusicVideo
//
//  Created by Mubbasher Khanzada on 06/08/2016.
//  Copyright © 2016 EnablingPeople. All rights reserved.
//

import UIKit

var reachability : Reachability?
var reachabilityStatus = WIFI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var internetCheck : Reachability?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        NotificationCenter.default.addObserver(self, selector: Selector(("reachabilityChanged")), name: .reachabilityChanged, object: nil)
        
        internetCheck = Reachability.forInternetConnection()
        internetCheck?.startNotifier()
        
        return true
    }
    
    func reachabilityChanged(notification: NSNotification) {
        reachability = notification.object as? Reachability
        statusChangedWithReachability(currentReachabilityStatus: reachability!)
    }
    
    func statusChangedWithReachability(currentReachabilityStatus: Reachability){
        
        let networkStatus : NetworkStatus = currentReachabilityStatus.currentReachabilityStatus()
        
        switch networkStatus.rawValue {
        case NotReachable.rawValue : reachabilityStatus = NOACCESS
        case ReachableViaWiFi.rawValue : reachabilityStatus = WIFI
        case ReachableViaWWAN.rawValue : reachabilityStatus = WWAN
        default : return
        }
        NotificationCenter.default.post(name: "ReachStatusChanged" as NSNotification.Name, object: nil)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
        
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        
    }


}

