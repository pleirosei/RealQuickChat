//
//  AppDelegate.swift
//  QuickChat
//
//  Created by Sean Livingston on 2/10/15.
//  Copyright (c) 2015 ElevenFifty. All rights reserved.
//
//  http://bit.ly/1Abizl5
//


/*  From here, to done.....
    1: In Images.xcassets, add the App Icons
    2: Customize LaunchScreen.xib - or - Use Launch image files
    3: Choose a device to run on (not the simulator)
    4: Product -> Archive
    5: Go to developer.apple.com -> identifiers -> create an app id
       Use the bundle identifier found under the top level project
    6: Go to itunesconnect.apple.com -> create app -> choose app id you just
       created in step #6
    7: Xcode -> Window -> Organizer -> Archive -> Submit
    8: Fill out lots of paper work
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        [Parse setApplicationId:@"5KsessEBuTyL8aMzy6W2uGx5TVrY69zuTgnIVFlc"
//        clientKey:@"nIajA3eY7qNG1oi5jr5c9lQTNRI9vm3fKyjByQdk"];

        // This parse application ID belongs to me
        
       Parse.setApplicationId("5KsessEBuTyL8aMzy6W2uGx5TVrY69zuTgnIVFlc", clientKey: "nIajA3eY7qNG1oi5jr5c9lQTNRI9vm3fKyjByQdk")
        
       
        
        PFTwitterUtils.initializeWithConsumerKey("m5B2PkbwpIH1HoB8NRTeLfQs1", consumerSecret: "Q1MHKjIM4BrbmzG8MaV3U8zbsdjnsvLkPHquYvLV09lQ51gpPt")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

