
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

class NetworkHelper: NSObject {
  
  static private var networkCommunicationCount = 0
  
  // MARK: - Static Private Methods
  
  static private func requestGet(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
      networkManager.GET(url, parameters: parameter, success: { (operation, responseObject) -> Void in
        self.processResponse(operation, responseObject: responseObject, error: nil, success: success, failure: failure)
        },
        failure: { (operation, error) -> Void in
          self.processResponse(operation, responseObject: operation.responseObject, error: error,
            success: success, failure: failure)
      })
  }
  
  static private func requestPost(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
      networkManager.POST(url, parameters: parameter, success: { (operation, responseObject) -> Void in
        self.processResponse(operation, responseObject: responseObject, error: nil, success: success, failure: failure)
        },
        failure: { (operation, error) -> Void in
          self.processResponse(operation, responseObject: operation.responseObject, error: error,
            success: success, failure: failure)
      })
  }
  
  static private func requestPut(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
      networkManager.PUT(url, parameters: parameter, success: { (operation, responseObject) -> Void in
        self.processResponse(operation, responseObject: responseObject, error: nil, success: success, failure: failure)
        },
        failure: { (operation, error) -> Void in
          self.processResponse(operation, responseObject: operation.responseObject, error: error,
            success: success, failure: failure)
      })
  }
  
  static private func requestDelete(url: String, parameter: AnyObject?, success: NetworkSuccess?, failure: NetworkFailure?) {
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
      subtractNetworkCount()
  }
  
  static private func addNetworkCount() {
    networkCommunicationCount += 1
    if networkCommunicationCount == 1 {
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationNetworkStart, object: nil)
    }
  }
  
  static private func subtractNetworkCount() {
    networkCommunicationCount -= 1
    if networkCommunicationCount == 0 {
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationNetworkEnd, object: nil)
    }
  }
  
  // MARK: - Static Public Methods
  
  static func request(method: NetworkMethod, url: String, parameter: AnyObject?,
    success: NetworkSuccess?, failure: NetworkFailure?) {
      print("\(method) \(url)")
      addNetworkCount()
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
  
  static func request(method: NetworkMethod, url: String, parameter: AnyObject?, success: NetworkSuccess?) {
    request(method, url: url, parameter: parameter, success: success, failure: nil)
  }
  
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
          self.processResponse(operation,
            responseObject: responseObject,
            error: nil,
            success: success,
            failure: failure)
          }, failure: { (operation, error) -> Void in
            self.processResponse(operation,
              responseObject: operation.responseObject,
              error: error,
              success: success,
              failure: failure)
        })
        operation.start()
      }
      
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
