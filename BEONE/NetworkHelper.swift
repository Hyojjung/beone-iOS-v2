//
//  NetworkHelper.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit
import AFNetworking

typealias NetworkSuccess = (result: AnyObject?) -> Void
typealias NetworkFailure = (error: NetworkError) -> Void

enum NetworkMethod: String {
  case Get = "GET"
  case Post = "POST"
  case Put = "PUT"
  case Delete = "DELETE"
}

let kNetworkResponseKeyData = "data"

let kNetworkHeaderKeyContentType = "Content-Type"
let kNetworkHeaderValueContentType = "application/json"

let kHeaderAuthorizationKey = "x-beone-authorization"

// TODO: 주소수정
#if DEBUG
let kBaseApiUrl = "http://52.68.151.169/api/"
let kBaseUrl = "http://52.68.151.169/"
  #else
let kBaseApiUrl = "https://devapp.beone.kr/api/"
let kBaseUrl = "https://devapp.beone.kr/"
#endif

class NetworkHelper: NSObject {
  
  // MARK: - Static Private Methods
  
  static private func requestGet(url: String, parameter: AnyObject?, networkManager: AFHTTPRequestOperationManager,
    success: NetworkSuccess?, failure: NetworkFailure?) {
      networkManager.GET(url, parameters: parameter, success: { (operation, responseObject) -> Void in
        self.processResponse(operation, responseObject: responseObject, error: nil, success: success, failure: failure)
        },
        failure: { (operation, error) -> Void in
          self.processResponse(operation, responseObject: operation.responseObject, error: error,
            success: success, failure: failure)
      })
  }
  
  static private func requestPost(url: String, parameter: AnyObject?, networkManager: AFHTTPRequestOperationManager,
    success: NetworkSuccess?, failure: NetworkFailure?) {
      networkManager.POST(url, parameters: parameter, success: { (operation, responseObject) -> Void in
        self.processResponse(operation, responseObject: responseObject, error: nil, success: success, failure: failure)
        },
        failure: { (operation, error) -> Void in
          self.processResponse(operation, responseObject: operation.responseObject, error: error,
            success: success, failure: failure)
      })
  }
  
  static private func requestPut(url: String, parameter: AnyObject?, networkManager: AFHTTPRequestOperationManager,
    success: NetworkSuccess?, failure: NetworkFailure?) {
      networkManager.PUT(url, parameters: parameter, success: { (operation, responseObject) -> Void in
        self.processResponse(operation, responseObject: responseObject, error: nil, success: success, failure: failure)
        },
        failure: { (operation, error) -> Void in
          self.processResponse(operation, responseObject: operation.responseObject, error: error,
            success: success, failure: failure)
      })
  }
  
  static private func requestDelete(url: String, parameter: AnyObject?, networkManager: AFHTTPRequestOperationManager,
    success: NetworkSuccess?, failure: NetworkFailure?) {
      networkManager.DELETE(url, parameters: parameter, success: { (operation, responseObject) -> Void in
        self.processResponse(operation, responseObject: responseObject, error: nil, success: success, failure: failure)
        },
        failure: { (operation, error) -> Void in
          self.processResponse(operation, responseObject: operation.responseObject, error: error,
            success: success, failure: failure)
      })
  }
  
  static private func processResponse(operation: AFHTTPRequestOperation, responseObject: AnyObject?, error: NSError?,
    success: NetworkSuccess?, failure: NetworkFailure?) {
      print("\(operation.response?.statusCode) \(operation.request.URL)")
      print("responseObject: \(responseObject)")
      if let error = error {
        if operation.response == nil ||
          operation.response?.statusCode == NetworkResponseCode.None.rawValue ||
          operation.response?.statusCode == NetworkResponseCode.BadGateWay.rawValue ||
          operation.response?.statusCode == NetworkResponseCode.ServiceUnavailable.rawValue {
            // TODO: show alert view with "check network"
        } else if operation.response?.statusCode == NetworkResponseCode.SomethingWrongInServer.rawValue {
          // TODO: show alert view with "something wrong in server"
        }
        
        if let response = operation.response {
          let networkError =
          NetworkError(statusCode: response.statusCode, originalErrorCode: error.code, responseObject: responseObject)
          if let failure = failure {
            failure(error: networkError)
          }
          // TODO: handle common error
        }
      } else if let success = success {
        success(result: responseObject)
      }
  }
  
  static private func networkManager() -> AFHTTPRequestOperationManager {
    let networkManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: kBaseApiUrl))
    networkManager.requestSerializer = AFJSONRequestSerializer()
    return networkManager
  }
  
  // MARK: - Static Public Methods
  
  static func request(method: NetworkMethod, url: String, parameter: AnyObject?,
    success: NetworkSuccess?, failure: NetworkFailure?) {
      print("\(method) \(url)")
      let networkManager = self.networkManager()
      switch method {
      case NetworkMethod.Get:
        requestGet(url, parameter: parameter, networkManager: networkManager, success: success, failure: failure)
      case NetworkMethod.Post:
        requestPost(url, parameter: parameter, networkManager: networkManager, success: success, failure: failure)
      case NetworkMethod.Put:
        requestPut(url, parameter: parameter, networkManager: networkManager, success: success, failure: failure)
      case NetworkMethod.Delete:
        requestDelete(url, parameter: parameter, networkManager: networkManager, success: success, failure: failure)
      }
  }
  
  static func request(method: NetworkMethod, url: String, parameter: AnyObject?, success: NetworkSuccess?) {
    request(method, url: url, parameter: parameter, success: success, failure: nil)
  }
}
