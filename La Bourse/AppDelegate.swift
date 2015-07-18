//
//  AppDelegate.swift
//  La Bourse
//
//  Created by Alexandre NGUYEN on 14/07/15.
//  Copyright (c) 2015 Librairie La Bourse. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |
            UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        var dailyNotificationTimer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: Selector("dailyNotification"), userInfo: nil, repeats: true)

        return true
    }
    
    func dailyNotification() {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        if((hour == 20 && minutes == 30) || (hour == 10 && minutes == 30)) {
            
            let url = NSURL(string: "http://data.librairielabourse.fr/storeSales/today")
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                
                let json = JSON(data: data)
                
                var total = 0.0;
                
                for (key: String, subJson: JSON) in json {
                    
                    if key == "today" {
                        for (subKey: String, subSubJson: JSON) in subJson {
                            total += subSubJson["chiffre_journee"].doubleValue
                        }
                    }
                }
                
                var localNotification: UILocalNotification = UILocalNotification()
                
                if(hour == 20 && minutes == 30) {
                    localNotification.alertAction = "La Bourse - Fin de journée"
                    localNotification.alertBody = "La journée est terminée. Votre chiffre d'affaire est de " + String(format:"%.2f", total) + " €."
                }
                else if(hour == 10 && minutes == 30) {
                    localNotification.alertAction = "La Bourse - Bonjour !"
                    localNotification.alertBody = "La journée commence, il est 10H30. Vous commencez à " + String(format:"%.2f", total) + " €."
                }
                
                localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
            
            task.resume()
        }
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

