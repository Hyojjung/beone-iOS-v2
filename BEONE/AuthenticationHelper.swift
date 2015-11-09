
import UIKit
import FBSDKLoginKit

let kRequestUrlUsers = "users"
let kRequestUrlAuthentications = "authentications"

let kMyInfoPropertyKeyDeviceType = "deviceType"
let kMyInfoPropertyKeyDeviceToken = "deviceToken"
let kAuthenticationPropertyKeyDeviceInfoId = "deviceInfoId"
let kAuthenticationPropertyKeyRefreshToken = "refreshToken"
let kAuthenticationPropertyKeyAccessToken = "accessToken"

let kSigningParameterKeyPassword = "password"
let kSigningParameterKeyAccount = "account"
let kSigningParameterKeyEmail = "email"
let kSigningParameterKeyName = "name"
let kSigningParameterKeySnsType = "snsType"
let kSigningParameterKeyUserId = "uid"
let kSigningParameterKeySnsToken = "snsToken"
let kSigningParameterKeyUserType = "userType"

let kSigningResponseKeyDeviceInfos = "deviceInfos"
let kSigningResponseKeyAuthentication = "authentication"
let kSigningResponseKeyDeviceInfo = "deviceInfo"

let kDeviceTypeiOS = "ios"
let kUserTypeGuest = "guest"
let kUserTypeSns = "sns"
let kUserTypeAccount = "account"

enum SnsType: String {
  case Facebook = "facebook"
  case Kakao = "kakao"
}

class AuthenticationHelper: NSObject {
  
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
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningSuccess, object: nil)
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
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningSuccess, object: nil)
      },
      failure: { (error) -> Void in
        if error.statusCode == NetworkResponseCode.Invalid.rawValue &&
          error.errorKey == NetworkErrorKey.SnsInfos.rawValue &&
          error.errorCode == NetworkErrorCode.Invalid.rawValue {
          NSNotificationCenter.defaultCenter().postNotificationName(kNotificationNeedSignUp, object: nil)
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
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningSuccess, object: nil)
      },
      failure: { (error) -> Void in
        if error.statusCode == NetworkResponseCode.Duplicated.rawValue {
          NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningFailure, object: nil)
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
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningSuccess, object: nil)
      },
      failure:nil)
  }
  
  static func saveMyInfo(result: [String: AnyObject]?, isNewUserResponse: Bool) {
    print(result)
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
      }
      CoreDataHelper.sharedCoreDataHelper.saveContext()
    }
  }
  
  static func registerDeviceInfo(success: NetworkSuccess) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = kDeviceTypeiOS
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    
    NetworkHelper.requestPost("device-infos", parameter: parameter,
      success: { (result) -> Void in
        if let deviceInfo = result![kNetworkResponseKeyData] as? [String: AnyObject] {
          myInfo.userDeviceInfoId = deviceInfo[kObjectPropertyKeyId] as? NSNumber
          CoreDataHelper.sharedCoreDataHelper.saveContext()
        }
        success(result: result)
      },
      failure: nil)
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
  
  static func refreshToken(success: NetworkSuccess) {
    let myInfo = MyInfo.sharedMyInfo()
    if let authenticationId = myInfo.authenticationId {
      var parameter = [String: AnyObject]()
      parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
      parameter[kAuthenticationPropertyKeyRefreshToken] = myInfo.refreshToken
      
      NetworkHelper.requestPut("\(kRequestUrlAuthentications)/\(authenticationId)", parameter: parameter,
        success: { (result) -> Void in
          saveMyInfo(result as? [String: AnyObject], isNewUserResponse: false)
          success(result: result)
        },
        failure: { (error) -> Void in
          if error.statusCode == NetworkResponseCode.NotFound.rawValue {
            registerDeviceInfo(success)
          }
      })
    }
  }
  
  // MARK: - Sns Methods
  
  static func requestFacebookSignIn() {
    AuthenticationHelper.signIn(SnsType.Facebook,
      userId: FBSDKAccessToken.currentAccessToken().userID,
      token: FBSDKAccessToken.currentAccessToken().tokenString)
  }
  
  static func getFaceBookInfo() {
    var parameter = [String: String]()
    parameter["fields"] = "name, email"
    
    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: parameter)
    graphRequest.startWithCompletionHandler { (_, result, _) -> Void in
      if let result = result as? [String: AnyObject]{
        var userInfo = [String: String]()
        userInfo[kNotificationKeyFacebookName] = result["name"] as? String
        userInfo[kNotificationKeyFacebookEmail] = result["email"] as? String
        
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationFetchFacebookInfoSuccess,
          object: nil,
          userInfo: userInfo)
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
  
  static func requestKakaoSignIn() {
    kakaoSessionMeTask() { (user) -> Void in
      AuthenticationHelper.signIn(SnsType.Kakao,
        userId: user.ID.description,
        token: KOSession.sharedSession().accessToken)
    }
  }
  
  static func getKakaoInfo() {
    kakaoSessionMeTask() { (user) -> Void in
      var userInfo = [String: String]()
      userInfo[kNotificationKeyFacebookName] = user.propertyForKey("nickname") as? String
      
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationFetchKakaoInfoSuccess,
        object: nil,
        userInfo: userInfo)
    }
  }
}
