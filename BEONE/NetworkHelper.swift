
import UIKit
import AFNetworking

typealias NetworkSuccess = (result: AnyObject) -> Void
typealias NetworkFailure = (error: NetworkError) -> Void

enum NetworkMethod: String {
  case Get = "GET"
  case Post = "POST"
  case Put = "PUT"
  case Delete = "DELETE"
}

let kNetworkResponseKeyData = "data"
let kNetworkResponseKeyError = "error"
let kNetworkErrorKeyCode = "code"
let kNetworkErrorKeyKey = "key"

let kNetworkHeaderKeyContentType = "Content-Type"
let kNetworkHeaderValueContentType = "application/json"

let kHeaderAuthorizationKey = "x-beone-authorization"
let kBOHeaderVersionKey = "x-beone-version"
let kBOHeaderVersion = "v2.0"

//#if DEBUG
//let kBaseApiUrl = "https://dev-api.beone.kr/"
//let kBaseUrl = "https://dev-api.beone.kr/"
//#else
let kBaseApiUrl = "https://api.beone.kr/"
let kBaseUrl = "https://api.beone.kr/"
//#endif

enum NetworkErrorCode: Int {
  case TokenExpired = 1101
  case Invalid = 1100
  case NothingMathed = 1001
}

enum NetworkErrorKey: String {
  case AccessToken = "accessToken"
  case RefreshToken = "refreshToken"
  case Uid = "uid"
}

class NetworkHelper: NSObject {
  
  static private var networkCommunicationCount = 0
  
  // MARK: - Static Private Methods
  
  static private func request(method: NetworkMethod, url: String, parameter: AnyObject?,
                              success: NetworkSuccess?, failure: NetworkFailure?) {
    #if DEBUG
      print("\(method) \(url)")
    #endif
    switch method {
    case .Get:
      requestGet(url, parameter: parameter, success: success, failure: failure)
    case .Post:
      requestPost(url, parameter: parameter, success: success, failure: failure)
    case .Put:
      requestPut(url, parameter: parameter, success: success, failure: failure)
    case .Delete:
      requestDelete(url, parameter: parameter, success: success, failure: failure)
    }
  }
  
  static private func handleErrorDefault(operation: AFHTTPRequestOperation?, responseObject: AnyObject?, error: NSError, success: NetworkSuccess?, failure: NetworkFailure?) {
    #if DEBUG
      if let responseObject = responseObject {
        do {
          let jsonData = try NSJSONSerialization.dataWithJSONObject(responseObject, options: NSJSONWritingOptions.PrettyPrinted)
          print("\(operation?.response?.statusCode) \(operation?.response?.URL)")
          print("responseObject: \(NSString(data: jsonData, encoding: NSUTF8StringEncoding))")
        } catch let error as NSError {
          print(error.description)
        }
      }
    #endif
    let responseObject = responseObject as? [String: AnyObject]
    if let statusCode = operation?.response?.statusCode {
      var errorCode: Int? = nil
      var errorKey: String? = nil
      if let errorObject = responseObject?[kNetworkResponseKeyError] as? [String: String] {
        errorCode = responseObject?[kNetworkErrorKeyCode] as? Int
        errorKey = errorObject[kNetworkErrorKeyKey]
      }
      let myInfo = MyInfo.sharedMyInfo()
      if statusCode == NetworkResponseCode.BadGateWay.rawValue || statusCode == NetworkResponseCode.ServiceUnavailable.rawValue {
        ViewControllerHelper.showServerCheckViewController()
      } else if operation?.response?.statusCode == NetworkResponseCode.SomethingWrongInServer.rawValue {
        ViewControllerHelper.topRootViewController()?.showAlertView("서버에 문제가 있습니다. 잠시 후 다시 시도해주세요.")
      } else if statusCode == NetworkResponseCode.NeedAuthority.rawValue {
        if errorCode != nil && errorKey != nil {
          if errorCode == NetworkErrorCode.Invalid.rawValue && errorKey == NetworkErrorKey.AccessToken.rawValue && !myInfo.isUser() {
            requestFailureRequest(operation, success: success, failure: failure)
          } else if errorCode == NetworkErrorCode.TokenExpired.rawValue && errorKey == NetworkErrorKey.AccessToken.rawValue && !myInfo.isUser() {
            myInfo.accessToken = nil
            SigningHelper.signInForNonUser(signingSuccess(operation, success: success, failure: failure))
          } else if errorCode == NetworkErrorCode.TokenExpired.rawValue && errorKey == NetworkErrorKey.RefreshToken.rawValue {
            myInfo.refreshToken = nil
            SigningHelper.signInForNonUser(success)
          } else if (errorCode == NetworkErrorCode.TokenExpired.rawValue || errorCode == NetworkErrorCode.Invalid.rawValue) &&
            errorKey == NetworkErrorKey.AccessToken.rawValue {
            myInfo.accessToken = nil
            AuthenticationHelper.refreshToken(signingSuccess(operation, success: success, failure: failure))
          }
        }
      }
      
      if let response = operation?.response, statusCode = NetworkResponseCode(rawValue: response.statusCode) {
        let networkError =
          NetworkError(statusCode: statusCode
            , errorCode: errorCode, errorKey: errorKey, responseObject: responseObject)
        
        if let failure = failure {
          failure(error: networkError)
        }
      }
    } else {
      ViewControllerHelper.showNetworkErrorViewController()
    }
    subtractNetworkCount()
  }
  
  static private func signingSuccess(operation: AFHTTPRequestOperation?, success: NetworkSuccess?, failure: NetworkFailure?) -> NetworkSuccess {
    return { (result) -> Void in
      requestFailureRequest(operation, success: success, failure: failure)
    }
  }
  
  static private func requestFailureRequest(operation: AFHTTPRequestOperation?, success: NetworkSuccess?, failure: NetworkFailure?) {
    let parameter: AnyObject?
    if let httpBody = operation?.request.HTTPBody {
      do {
        try parameter = NSJSONSerialization.JSONObjectWithData(httpBody, options: .MutableContainers)
      } catch {
        parameter = nil
      }
    } else {
      parameter = nil
    }
    
    if let url = operation?.request.URL?.absoluteString.stringByReplacingOccurrencesOfString(kBaseApiUrl, withString:kEmptyString),
      httpMethodString = operation?.request.HTTPMethod,
      method = NetworkMethod(rawValue: httpMethodString) {
      request(method, url: url, parameter: parameter, success: success, failure: failure)
    }
  }
  
  static private func handleSuccessDefault(operation: AFHTTPRequestOperation?, responseObject: AnyObject?, success: NetworkSuccess?) {
    #if DEBUG
      print("\(operation?.response?.statusCode) \(operation?.response?.URL)")
    #endif
    if let success = success, responseObject = responseObject {
      
      if let responseObject = responseObject as? [String: AnyObject],
        actionObject = responseObject["action"] as? [String: AnyObject] {
        let action = Action()
        action.assignObject(actionObject)
        action.action()
      }
      success(result: responseObject)
    }
    subtractNetworkCount()
  }
  
  static private func addNetworkCount() {
    networkCommunicationCount += 1
    if networkCommunicationCount <= 1 {
      postNotification(kNotificationNetworkStart)
    }
  }
  
  static private func subtractNetworkCount() {
    networkCommunicationCount -= 1
    if networkCommunicationCount == 0 {
      postNotification(kNotificationNetworkEnd)
    }
  }
  
  // MARK: - Public Static Methods
  
  static func uploadData(signedUrl: String?, contentType: String, parameters: NSData,
                         success: NetworkSuccess?, failure: NetworkFailure?) {
    if let signedUrl = signedUrl {
      addNetworkCount()
      let request = NSMutableURLRequest(URL: NSURL(string: signedUrl)!,
                                        cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                                        timeoutInterval: 10)
      request.setValue(contentType, forHTTPHeaderField: kNetworkHeaderKeyContentType)
      request.HTTPMethod = NetworkMethod.Put.rawValue
      request.HTTPBody = parameters
      
      let operation = AFHTTPRequestOperation(request: request)
      operation.responseSerializer = AFJSONResponseSerializer()
      operation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
        success?(result: responseObject)
        subtractNetworkCount()
        }, failure: { (operation, error) -> Void in
          self.handleErrorDefault(operation, responseObject: operation.responseObject, error: error, success: success, failure: failure)
      })
      operation.start()
    }
    
  }
}

// MARK: - CRUD Methods

extension NetworkHelper {
  static func requestGet(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure? = nil) {
    addNetworkCount()
    
    var param: [String: AnyObject]
    if parameter == nil {
      param = [String: AnyObject]()
    } else {
      param = parameter as! [String: AnyObject]
    }
    if param[kNetworkRequestKeyLocationId] == nil && !url.containsString(kNetworkRequestKeyLocationId) {
      if let speedOrderLocationId = BEONEManager.speedOrderLocationId {
        param[kNetworkRequestKeyLocationId] = speedOrderLocationId
      } else {
        param[kNetworkRequestKeyLocationId] = BEONEManager.selectedLocation?.id
      }
    }
    
    networkManager.GET(url, parameters: param, success: { (operation, responseObject) -> Void in
      self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
      }, failure: { (operation, error) -> Void in
        self.handleErrorDefault(operation, responseObject: operation?.responseObject, error: error,
          success: success, failure: failure)
    })
  }
  
  static func requestPost(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure? = nil) {
    addNetworkCount()
    networkManager.POST(url, parameters: parameter, success: { (operation, responseObject) -> Void in
      self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
      }, failure: { (operation, error) -> Void in
        self.handleErrorDefault(operation, responseObject: operation?.responseObject, error: error,
          success: success, failure: failure)
    })
  }
  
  static func requestPut(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
    addNetworkCount()
    networkManager.PUT(url, parameters: parameter, success: { (operation, responseObject) -> Void in
      self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
      }, failure: { (operation, error) -> Void in
        self.handleErrorDefault(operation, responseObject: operation?.responseObject, error: error,
          success: success, failure: failure)
    })
  }
  
  static func requestDelete(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure? = nil) {
    addNetworkCount()
    networkManager.DELETE(url, parameters: parameter, success: { (operation, responseObject) -> Void in
      self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
      }, failure: { (operation, error) -> Void in
        self.handleErrorDefault(operation, responseObject: operation?.responseObject, error: error,
          success: success, failure: failure)
    })
  }
}

extension NetworkHelper {
  
  static var networkManager: AFHTTPRequestOperationManager {
    let networkManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: kBaseApiUrl))
    networkManager.requestSerializer = AFJSONRequestSerializer()
    if let accessToken = MyInfo.sharedMyInfo().accessToken {
      networkManager.requestSerializer.setValue(accessToken, forHTTPHeaderField: kHeaderAuthorizationKey)
      networkManager.requestSerializer.setValue(kBOHeaderVersion, forHTTPHeaderField: kBOHeaderVersionKey)
    }
    return networkManager
  }
}
