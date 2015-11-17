
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

// TODO: 주소수정
#if DEBUG
let kBaseApiUrl = "https://devapi.beone.kr/"
let kBaseUrl = "https://devapi.beone.kr/"
#else
let kBaseApiUrl = "https://devapi.beone.kr/"
let kBaseUrl = "https://devapi.beone.kr/"
#endif

enum NetworkErrorCode: String {
  case TokenExpired = "1002"
  case Invalid = "1001"
}

enum NetworkErrorKey: String {
  case AccessToken = "accessToken"
  case RefreshToken = "refreshToken"
  case SnsInfos = "snsInfos"
}

class NetworkHelper: NSObject {
  
  static private var networkCommunicationCount = 0
  
  // MARK: - Static Private Methods
  
  static private func request(method: NetworkMethod, url: String, parameter: AnyObject?,
    success: NetworkSuccess?, failure: NetworkFailure?) {
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
  
  
  static private func handleErrorDefault(operation: AFHTTPRequestOperation, responseObject: AnyObject?, error: NSError, success: NetworkSuccess?, failure: NetworkFailure?) {
    #if DEBUG
      print("\(operation.response?.statusCode) \(operation.request.URL)")
      print("responseObject: \(responseObject)")
    #endif
    
    if let responseObject = responseObject, statusCode = operation.response?.statusCode {
      var errorCode: String? = nil
      var errorKey: String? = nil
      if let errorObject = responseObject[kNetworkResponseKeyError] as? [String: String] {
        errorCode = errorObject[kNetworkErrorKeyCode]
        errorKey = errorObject[kNetworkErrorKeyKey]
      }
      let myInfo = MyInfo.sharedMyInfo()
      if statusCode == NetworkResponseCode.BadGateWay.rawValue || statusCode == NetworkResponseCode.ServiceUnavailable.rawValue {
        // TODO: show alert view with "서버 점검 중"
      } else if operation.response?.statusCode == NetworkResponseCode.SomethingWrongInServer.rawValue {
        // TODO: show alert view with "something wrong in server"
      } else if statusCode == NetworkResponseCode.Invalid.rawValue {
        if errorCode != nil && errorKey != nil {
          if errorCode == NetworkErrorCode.TokenExpired.rawValue && errorKey == NetworkErrorKey.AccessToken.rawValue && myInfo.refreshToken == nil {
            myInfo.accessToken = nil
            SigningHelper.signInForNonUser(signingSuccess(operation, success: success, failure: failure))
          } else if errorCode == NetworkErrorCode.TokenExpired.rawValue && errorKey == NetworkErrorKey.RefreshToken.rawValue {
            myInfo.refreshToken = nil
            SigningHelper.signInForNonUser(success)
          } else if errorCode == NetworkErrorCode.TokenExpired.rawValue && errorKey == NetworkErrorKey.AccessToken.rawValue {
            myInfo.accessToken = nil
            AuthenticationHelper.refreshToken(signingSuccess(operation, success: success, failure: failure))
          }
        }
      }
      
      if let response = operation.response {
        let networkError =
        NetworkError(statusCode: response.statusCode, errorCode: errorCode, errorKey: errorKey, responseObject: responseObject)
        
        if let failure = failure {
          failure(error: networkError)
        }
        // TODO: handle common error
      }
    } else {
      // TODO: show alert view with "check network"
    }
    subtractNetworkCount()
  }
  
  static private func signingSuccess(operation: AFHTTPRequestOperation, success: NetworkSuccess?, failure: NetworkFailure?) -> NetworkSuccess {
    return { (result) -> Void in
      let parameter: AnyObject?
      if let httpBody = operation.request.HTTPBody {
        do {
          try parameter = NSJSONSerialization.JSONObjectWithData(httpBody, options: .MutableContainers)
        } catch {
          parameter = nil
        }
      } else {
        parameter = nil
      }
      
      if let url = operation.request.URL?.absoluteString.stringByReplacingOccurrencesOfString(kBaseApiUrl, withString:""),
        httpMethodString = operation.request.HTTPMethod,
        method = NetworkMethod(rawValue: httpMethodString) {
          request(method, url: url, parameter: parameter, success: success, failure: failure)
      }
    }
  }
  
  
  static private func handleSuccessDefault(operation: AFHTTPRequestOperation, responseObject: AnyObject?, success: NetworkSuccess?) {
    #if DEBUG
      print("\(operation.response?.statusCode) \(operation.request.URL)")
    #endif
    if let success = success, responseObject = responseObject {
      success(result: responseObject)
    }
    subtractNetworkCount()
  }
  
  static private func addNetworkCount() {
    networkCommunicationCount += 1
    print("added \(networkCommunicationCount)")
    if networkCommunicationCount == 1 {
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationNetworkStart, object: nil)
    }
  }
  
  static private func subtractNetworkCount() {
    networkCommunicationCount -= 1
    print("subtracted \(networkCommunicationCount)")
    if networkCommunicationCount == 0 {
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationNetworkEnd, object: nil)
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
          self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
          }, failure: { (operation, error) -> Void in
            self.handleErrorDefault(operation, responseObject: operation.responseObject, error: error, success: success, failure: failure)
        })
        operation.start()
      }
      
  }
}

// MARK: - CRUD Methods

extension NetworkHelper {
  static func requestGet(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
    #if DEBUG
      print("GET \(url)")
    #endif
    addNetworkCount()
    networkManager.GET(url, parameters: parameter, success: { (operation, responseObject) -> Void in
      self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
      },
      failure: { (operation, error) -> Void in
        self.handleErrorDefault(operation, responseObject: operation.responseObject, error: error,
          success: success, failure: failure)
    })
  }
  
  static func requestPost(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
    #if DEBUG
      print("POST \(url)")
    #endif
    addNetworkCount()
    networkManager.POST(url, parameters: parameter, success: { (operation, responseObject) -> Void in
      self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
      },
      failure: { (operation, error) -> Void in
        self.handleErrorDefault(operation, responseObject: operation.responseObject, error: error,
          success: success, failure: failure)
    })
  }
  
  static func requestPut(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
    #if DEBUG
      print("PUT \(url)")
    #endif
    addNetworkCount()
    networkManager.PUT(url, parameters: parameter, success: { (operation, responseObject) -> Void in
      self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
      },
      failure: { (operation, error) -> Void in
        self.handleErrorDefault(operation, responseObject: operation.responseObject, error: error,
          success: success, failure: failure)
    })
  }
  
  static func requestDelete(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
    #if DEBUG
      print("DELETE \(url)")
    #endif
    addNetworkCount()
    networkManager.DELETE(url, parameters: parameter, success: { (operation, responseObject) -> Void in
      self.handleSuccessDefault(operation, responseObject: responseObject, success: success)
      },
      failure: { (operation, error) -> Void in
        self.handleErrorDefault(operation, responseObject: operation.responseObject, error: error,
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
    }
    return networkManager
  }
}
