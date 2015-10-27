//
//  AuthenticationHelper.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

let kNotificationSigningSuccess = "NotificationSigningSuccess"

let kRequestUrlUsers = "users"
let kRequestUrlAuthentications = "authentications"

let kMyInfoPropertyKeyDeviceType = "deviceType"
let kMyInfoPropertyKeyDeviceToken = "deviceToken"
let kAuthenticationPropertyKeyDeviceInfoId = "deviceInfoId"
let kAuthenticationPropertyKeyRefreshToken = "refreshToken"
let kAuthenticationPropertyKeyAccessToken = "accessToken"

let kSigningParameterKeyPassword = "password"
let kSigningParameterKeyEmail = "email"
let kSigningParameterKeyName = "name"
let kSigningParameterKeySnsType = "snsType"
let kSigningParameterKeyUserId = "uid"
let kSigningParameterKeySnsToken = "snsToken"

let kSigningResponseKeyDeviceInfos = "deviceInfos"
let kSigningResponseKeyAuthentication = "authentication"
let kSigningResponseKeyDeviceInfo = "deviceInfo"


let kObjectPropertyKeyId = "id"

enum SnsType: Int {
  case Facebook = 1
  case Kakao
}

class AuthenticationHelper: NSObject {
  
  // MARK: - Static Public Methods
  
  static func signIn(email: String, password: String) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = 1 // TODO: string으로 변경
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeyPassword] = password
    parameter[kSigningParameterKeyEmail] = email
    NetworkHelper.request(NetworkMethod.Put, url: kRequestUrlAuthentications, parameter: parameter)
      { (result) -> Void in
        saveMyInfo(result as? [String: AnyObject], isNewUserResponse: false)
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningSuccess, object: nil)
    }
  }
  
  static func signIn(snsType: SnsType, userId: String, token: String) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = 1 // TODO: string으로 변경
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeySnsType] = snsType.rawValue
    parameter[kSigningParameterKeyUserId] = userId
    parameter[kSigningParameterKeySnsToken] = token
    NetworkHelper.request(NetworkMethod.Put, url: kRequestUrlAuthentications, parameter: parameter,
      success: { (result) -> Void in
        saveMyInfo(result as? [String: AnyObject], isNewUserResponse: false)
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningSuccess, object: nil)
      },
      failure: { (error) -> Void in
        // post noti
    })
  }
  
  static func signUp(email: String, name: String, password: String) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = 1 // TODO: string으로 변경
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeyPassword] = password
    parameter[kSigningParameterKeyName] = name
    parameter[kSigningParameterKeyEmail] = email
    NetworkHelper.request(NetworkMethod.Post, url: kRequestUrlUsers, parameter: parameter) { (result) -> Void in
      saveMyInfo(result as? [String: AnyObject], isNewUserResponse: true)
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningSuccess, object: nil)
    }
  }
  
  static func signUp(snsType: SnsType, userId: String, token: String, email: String, name: String) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = 1 // TODO: string으로 변경
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kSigningParameterKeySnsType] = snsType.rawValue
    parameter[kSigningParameterKeyUserId] = userId
    parameter[kSigningParameterKeySnsToken] = token
    parameter[kSigningParameterKeyName] = name
    parameter[kSigningParameterKeyEmail] = email
    NetworkHelper.request(NetworkMethod.Post, url: kRequestUrlUsers, parameter: parameter) { (result) -> Void in
      saveMyInfo(result as? [String: AnyObject], isNewUserResponse: true)
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSigningSuccess, object: nil)
    }
  }
  
  static func saveMyInfo(result: [String: AnyObject]?, isNewUserResponse: Bool) {
    let myInfo = MyInfo.sharedMyInfo()
    if let result = result {
      if isNewUserResponse {
        if let deviceInfos = result[kSigningResponseKeyDeviceInfos] as? [[String: AnyObject]],
          deviceInfo = deviceInfos.first,
          authentication = deviceInfo[kSigningResponseKeyAuthentication] as? [String: AnyObject] {
            myInfo.accessToken = authentication[kAuthenticationPropertyKeyAccessToken] as? String
            myInfo.refreshToken = authentication[kAuthenticationPropertyKeyRefreshToken] as? String
            myInfo.authenticationId = authentication[kObjectPropertyKeyId] as? NSNumber
            myInfo.userDeviceInfoId = deviceInfo[kObjectPropertyKeyId] as? NSNumber
        }
        myInfo.userId = result[kObjectPropertyKeyId] as? NSNumber
      } else if let deviceInfo = result[kSigningResponseKeyDeviceInfo] as? [String: AnyObject] {
        myInfo.accessToken = result[kAuthenticationPropertyKeyAccessToken] as? String
        myInfo.refreshToken = result[kAuthenticationPropertyKeyRefreshToken] as? String
        myInfo.authenticationId = result[kObjectPropertyKeyId] as? NSNumber
        myInfo.userDeviceInfoId = deviceInfo[kObjectPropertyKeyId] as? NSNumber
      }
      CoreDataHelper.sharedCoreDataHelper.saveContext()
    }
  }
  
  static func registerDeviceInfo(success: NetworkSuccess) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = 1 // TODO: string으로 변경
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    
    NetworkHelper.request(NetworkMethod.Post, url: "device-infos", parameter: parameter) { (result) -> Void in
      if let deviceInfo = result![kNetworkResponseKeyData] as? [String: AnyObject] {
        myInfo.userDeviceInfoId = deviceInfo[kObjectPropertyKeyId] as? NSNumber
      }
      success(result: result)
    }
  }
  
  static func signInForNonUser(success: NetworkSuccess) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = 1 // TODO: string으로 변경
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    
    NetworkHelper.request(NetworkMethod.Post, url: kRequestUrlAuthentications, parameter: parameter)
      { (result) -> Void in
        success(result: result)
    }
  }
  
  static func refreshToken(success: NetworkSuccess, failure: NetworkFailure) {
    let myInfo = MyInfo.sharedMyInfo()
    var parameter = [String: AnyObject]()
    parameter[kMyInfoPropertyKeyDeviceType] = 1 // TODO: string으로 변경
    parameter[kMyInfoPropertyKeyDeviceToken] = myInfo.deviceToken
    parameter[kAuthenticationPropertyKeyDeviceInfoId] = myInfo.userDeviceInfoId
    parameter[kAuthenticationPropertyKeyRefreshToken] = myInfo.refreshToken
    
    NetworkHelper.request(NetworkMethod.Post, url: kRequestUrlAuthentications, parameter: parameter,
      success: { (result) -> Void in
        success(result: result)
      },
      failure: { (error) -> Void in
        if error.statusCode == NetworkResponseCode.NotFound.rawValue {
          registerDeviceInfo(success)
        }
    })
  }
}
