
import UIKit
import Mixpanel

let kRequestUrlAuthentications = "authentications"

let kMyInfoPropertyKeyDeviceType = "deviceType"
let kMyInfoPropertyKeyDeviceToken = "deviceToken"
let kAuthenticationPropertyKeyDeviceInfoId = "deviceInfoId"
let kAuthenticationPropertyKeyRefreshToken = "refreshToken"
let kAuthenticationPropertyKeyAccessToken = "accessToken"

let kDeviceTypeiOS = "ios"

class AuthenticationHelper: NSObject {
  
  // MARK: - Static Public Methods

  static func registerDeviceInfo(success: NetworkSuccess) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = kDeviceTypeiOS
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter["uniqueToken"] = Mixpanel.sharedInstance().distinctId
    
    NetworkHelper.requestPost("device-infos", parameter: parameter,
      success: { (result) -> Void in
        if let deviceInfo = result[kNetworkResponseKeyData] as? [String: AnyObject] {
          NSUserDefaults.standardUserDefaults().setBool(true, forKey: kHasRegistedToken)
          myInfo.userDeviceInfoId = deviceInfo[kObjectPropertyKeyId] as? NSNumber
          CoreDataHelper.sharedCoreDataHelper.saveContext()
        }
        success(result: result)
      },
      failure: nil)
  }
  
  static func refreshToken(success: NetworkSuccess) {
    let myInfo = MyInfo.sharedMyInfo()
    if let authenticationId = myInfo.authenticationId {
      var parameter = [String: AnyObject]()
      parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
      parameter[kAuthenticationPropertyKeyRefreshToken] = myInfo.refreshToken

      NetworkHelper.requestPut("\(kRequestUrlAuthentications)/\(authenticationId)", parameter: parameter,
        success: { (result) -> Void in
          SigningHelper.saveMyInfo(result as? [String: AnyObject], isNewUserResponse: false)
          success(result: result)
        },
        failure: { (error) -> Void in
          if error.statusCode == NetworkResponseCode.NotFound {
            registerDeviceInfo(success)
          }
      })
    }
  }
}
