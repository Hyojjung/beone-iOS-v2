
import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
    application.registerUserNotificationSettings( settings )
    application.registerForRemoteNotifications()
    
    // Configure tracker from GoogleService-Info.plist.
    var configureError:NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil, "Error configuring Google services: \(configureError)")
    
    // Optional: configure GAI options.
    let gai = GAI.sharedInstance()
    gai.trackUncaughtExceptions = true  // report uncaught exceptions
    gai.logger.logLevel = GAILogLevel.None  // remove before app releaseAppDelegate.swift
    
    FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    return true
  }
  
  func application(application: UIApplication, openURL url: NSURL,
    sourceApplication: String?, annotation: AnyObject) -> Bool {
      if KOSession.isKakaoAccountLoginCallback(url) {
        return KOSession.handleOpenURL(url)
      }
      return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url,
        sourceApplication: sourceApplication, annotation: annotation)
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    KOSession.handleDidBecomeActive()
    FBSDKAppEvents.activateApp()
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    var tokenString = deviceToken.description
    tokenString = tokenString .stringByReplacingOccurrencesOfString("<", withString: String())
    tokenString = tokenString .stringByReplacingOccurrencesOfString(">", withString: String())
    tokenString = tokenString .stringByReplacingOccurrencesOfString(" ", withString: String())
    MyInfo.sharedMyInfo().deviceToken = tokenString
    if MyInfo.sharedMyInfo().userDeviceInfoId == nil || MyInfo.sharedMyInfo().userDeviceInfoId == 0 {
      AuthenticationHelper.registerDeviceInfo() { (result) -> Void in
        AuthenticationHelper.signInForNonUser(nil)
      }
    }
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    if MyInfo.sharedMyInfo().userDeviceInfoId == nil || MyInfo.sharedMyInfo().userDeviceInfoId == 0 {
      AuthenticationHelper.registerDeviceInfo() { (result) -> Void in
        AuthenticationHelper.signInForNonUser(nil)
      }
    }
  }
}
