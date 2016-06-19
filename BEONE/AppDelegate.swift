
import UIKit
import FBSDKCoreKit
import Fabric
import Crashlytics
import Mixpanel
import Flurry_iOS_SDK

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        let hasRegistedToken = NSUserDefaults.standardUserDefaults().objectForKey(kHasRegistedToken) as? Bool
        if hasRegistedToken != true {
            registerDeviceToken()
        }
        
        Fabric.with([Crashlytics.self])
        
        #if RELEASE
            //  GA 설정
            var configureError:NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")
            
            let gai = GAI.sharedInstance()
            gai.trackUncaughtExceptions = true
        #endif
        
        #if RELEAE
            // flurry 실서버 설정
            Flurry.startSession("W7D5JVZHPWCRTDTD8G6P")
            
        #else
            // flurry 개발서버 설정
            Flurry.startSession("6RS43CTX7XTRMT455G6Y")
            
        #endif
        
        Flurry.logEvent("Application Started")
        
        #if DEBUG
            let mixpanel = Mixpanel.sharedInstanceWithToken("5664ab63c207a56807d11dc603c7502b")
        #else
            let mixpanel = Mixpanel.sharedInstanceWithToken("d9a85727e5a1a3daf4c0b95243a74ed7")
        #endif
        mixpanel.identify(mixpanel.distinctId)
        mixpanel.people.increment(kMixpanelKeyLaunchCount, by: 1)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL,
                     sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.absoluteString.hasPrefix(kPaymentScheme) {
            if let orderWebViewController = ViewControllerHelper.topMostViewController() as? OrderWebViewController {
                orderWebViewController.handleUrl(url.absoluteString)
            }
            return true
        } else if url.absoluteString.containsString("productId") {
            let urlComponents = url.absoluteString.componentsSeparatedByString("productId=")
            if let productIdString = urlComponents.last, productId = Int(productIdString) {
                SchemeHelper.setUpScheme("home/product/\(productId)")
            }
            return true
        } else if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpenURL(url)
        } else if url.absoluteString.hasPrefix(kSchemeBaseUrl) {
            SchemeHelper.setUpScheme(url.absoluteString)
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     openURL: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
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
        CoreDataHelper.sharedCoreDataHelper.saveContext()
        
        registerDeviceToken()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        registerDeviceToken()
    }
    
    private func registerDeviceToken() {
        if MyInfo.sharedMyInfo().userDeviceInfoId == nil || MyInfo.sharedMyInfo().userDeviceInfoId == 0 {
            AuthenticationHelper.registerDeviceInfo() { (result) -> Void in
                SigningHelper.signInForNonUser({ (result) -> Void in
                    self.postNotification(kNotificationGuestAuthenticationSuccess)
                })
            }
        }
    }
}
