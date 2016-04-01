
import UIKit
import FBSDKLoginKit

let kRequestUrlUsers = "users"

let kSigningParameterKeyPassword = "password"
let kSigningParameterKeyAccount = "account"
let kSigningParameterKeyEmail = "email"
let kSigningParameterKeyName = kObjectPropertyKeyName
let kSigningParameterKeySnsType = "snsType"
let kSigningParameterKeyUserId = "uid"
let kSigningParameterKeySnsToken = "snsToken"
let kSigningParameterKeyUserType = "userType"

let kSigningResponseKeyDeviceInfos = "deviceInfos"
let kSigningResponseKeyAuthentication = "authentication"
let kSigningResponseKeyDeviceInfo = "deviceInfo"
let kSigningResponseKeyUser = "user"

let kUserTypeGuest = "guest"
let kUserTypeSns = "sns"
let kUserTypeAccount = "account"

enum SnsType: String {
  case Facebook = "facebook"
  case Kakao = "kakao"
}

class SigningHelper: NSObject {
  
  // MARK: - Static Public Methods
  
  static func signIn(email: String, password: String) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeyPassword] = password
    parameter[kSigningParameterKeyAccount] = email
    parameter[kSigningParameterKeyUserType] = kUserTypeAccount
    NetworkHelper.requestPost(kRequestUrlAuthentications, parameter: parameter,
      success: { (result) -> Void in
        saveMyInfo(result as? [String: AnyObject], isNewUserResponse: false)
        postNotification(kNotificationSigningSuccess)
      },
      failure: nil)
  }
  
  static func signIn(snsType: SnsType, userId: String, token: String) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeySnsType] = snsType.rawValue
    parameter[kSigningParameterKeyUserId] = userId
    parameter[kSigningParameterKeySnsToken] = token
    parameter[kSigningParameterKeyUserType] = kUserTypeSns
    NetworkHelper.requestPost(kRequestUrlAuthentications, parameter: parameter,
      success: { (result) -> Void in
        saveMyInfo(result as? [String: AnyObject], isNewUserResponse: false)
        postNotification(kNotificationSigningSuccess)
      },
      failure: { (error) -> Void in
        if error.statusCode == NetworkResponseCode.Invalid.rawValue &&
          error.errorKey == NetworkErrorKey.Uid.rawValue &&
          error.errorCode == NetworkErrorCode.NothingMathed.rawValue {
            postNotification(kNotificationNeedSignUp)
        }
    })
  }
  
  static func signUp(email: String, name: String, password: String) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeyPassword] = password
    parameter[kSigningParameterKeyName] = name
    parameter[kSigningParameterKeyEmail] = email
    parameter[kSigningParameterKeyUserType] = kUserTypeAccount
    NetworkHelper.requestPost(kRequestUrlUsers, parameter: parameter,
      success: { (result) -> Void in
        saveMyInfo(result as? [String: AnyObject], isNewUserResponse: true)
        postNotification(kNotificationSigningSuccess)
      },
      failure: { (error) -> Void in
        if error.statusCode == NetworkResponseCode.Duplicated.rawValue {
          postNotification(kNotificationSigningFailure)
        }
    })
  }
  
  static func signUp(snsType: SnsType, userId: String, token: String, email: String, name: String) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeySnsType] = snsType.rawValue
    parameter[kSigningParameterKeyUserId] = userId
    parameter[kSigningParameterKeySnsToken] = token
    parameter[kSigningParameterKeyName] = name
    parameter[kSigningParameterKeyEmail] = email
    parameter[kSigningParameterKeyUserType] = kUserTypeSns
    NetworkHelper.requestPost(kRequestUrlUsers, parameter: parameter,
      success: { (result) -> Void in
        saveMyInfo(result as? [String: AnyObject], isNewUserResponse: true)
        postNotification(kNotificationSigningSuccess)
      },
      failure:nil)
  }
  
  static func saveMyInfo(result: [String: AnyObject]?, isNewUserResponse: Bool) {
    let myInfo = MyInfo.sharedMyInfo()
    if let result = result, data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
      if isNewUserResponse {
        if let deviceInfos = data[kSigningResponseKeyDeviceInfos] as? [[String: AnyObject]],
          deviceInfo = deviceInfos.first,
          authentication = deviceInfo[kSigningResponseKeyAuthentication] as? [String: AnyObject] {
            myInfo.accessToken = authentication[kAuthenticationPropertyKeyAccessToken] as? String
            myInfo.refreshToken = authentication[kAuthenticationPropertyKeyRefreshToken] as? String
            myInfo.authenticationId = authentication[kObjectPropertyKeyId] as? NSNumber
            myInfo.userDeviceInfoId = deviceInfo[kObjectPropertyKeyId] as? NSNumber
        }
        myInfo.userId = data[kObjectPropertyKeyId] as? NSNumber
      } else if let deviceInfo = data[kSigningResponseKeyDeviceInfo] as? [String: AnyObject] {
        myInfo.accessToken = data[kAuthenticationPropertyKeyAccessToken] as? String
        myInfo.refreshToken = data[kAuthenticationPropertyKeyRefreshToken] as? String
        myInfo.authenticationId = data[kObjectPropertyKeyId] as? NSNumber
        myInfo.userDeviceInfoId = deviceInfo[kObjectPropertyKeyId] as? NSNumber
        myInfo.userId = deviceInfo[kSigningResponseKeyUser]?[kObjectPropertyKeyId] as? NSNumber
      }
      CoreDataHelper.sharedCoreDataHelper.saveContext()
    }
  }
  
  static func signInForNonUser(success: NetworkSuccess?) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeyUserType] = kUserTypeGuest
    
    NetworkHelper.requestPost(kRequestUrlAuthentications, parameter: parameter,
      success: { (result) -> Void in
        saveMyInfo(result as? [String: AnyObject], isNewUserResponse: false)
        success?(result: result)
      },
      failure: nil)
  }
  
  static func requestFindingPassword(email: String) {
    NetworkHelper.requestPost("users/password-reset", parameter: [kSigningParameterKeyEmail: email], success: { (result) -> Void in
      postNotification(kNotificationRequestFindingPasswordSuccess)
      },
      failure: { (error) -> Void in
        if let statusCode = error.statusCode {
          let userInfo = [kNotificationKeyErrorStatusCode: statusCode]
          postNotification(kNotificationRequestFindingPasswordFailure, userInfo: userInfo)
        }
    })
  }
  
  // MARK: - Sns Methods
  
  static func requestFacebookSignIn() {
    SigningHelper.signIn(SnsType.Facebook,
      userId: FBSDKAccessToken.currentAccessToken().userID,
      token: FBSDKAccessToken.currentAccessToken().tokenString)
  }
  
  static func getFaceBookInfo() {
    var parameter = [String: String]()
    parameter["fields"] = "\(kSigningParameterKeyName), \(kSigningParameterKeyEmail)"
    
    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: parameter)
    graphRequest.startWithCompletionHandler { (_, result, _) -> Void in
      if let result = result as? [String: AnyObject]{
        var userInfo = [String: String]()
        userInfo[kNotificationKeyFacebookName] = result[kSigningParameterKeyName] as? String
        userInfo[kNotificationKeyFacebookEmail] = result[kSigningParameterKeyEmail] as? String
        postNotification(kNotificationFetchFacebookInfoSuccess, userInfo: userInfo)
      }
    }
  }
  
  static func kakaoSessionMeTask(completionHandler: KOUser -> Void) {
    KOSessionTask.meTaskWithCompletionHandler { (result, _) -> Void in
      if let user = result as? KOUser {
        completionHandler(user)
      }
    }
  }
  
  static func requestKakaoSignIn(success: (uid: String, snsToken: String) -> Void) {
    kakaoSessionMeTask() { (user) -> Void in
      success(uid: user.ID.description, snsToken: KOSession.sharedSession().accessToken)
    }
  }
  
  static func getKakaoInfo() {
    kakaoSessionMeTask() { (user) -> Void in
      var userInfo = [String: String]()
      userInfo[kNotificationKeyFacebookName] = user.propertyForKey("nickname") as? String
      postNotification(kNotificationFetchKakaoInfoSuccess, userInfo: userInfo)
    }
  }
}
