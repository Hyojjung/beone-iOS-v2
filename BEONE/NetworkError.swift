
import UIKit

enum NetworkResponseCode: Int {
  case None
  case Success = 200
  case Invalid = 400
  case NeedAuthority
  case Forbidden = 403
  case NotFound
  case NotAllowed
  case Duplicated = 409
  case LogInTokenExpired
  case CannotGoThrough = 422
  case SomethingWrongInServer = 500
  case BadGateWay = 502
  case ServiceUnavailable = 503
}

struct NetworkError {
  
  var statusCode : NetworkResponseCode?
  var errorCode: Int?
  var errorKey: String?
  var responseObject : AnyObject?
  
  // MARK: - Init & Dealloc Methods
  
  init (statusCode: NetworkResponseCode?, errorCode: Int?, errorKey: String?, responseObject: AnyObject?) {
    self.statusCode = statusCode
    self.errorCode = errorCode
    self.errorKey = errorKey
    self.responseObject = responseObject
  }
}
