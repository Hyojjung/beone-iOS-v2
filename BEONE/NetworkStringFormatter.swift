
import UIKit

extension String {
  private func isUrlString() -> Bool {
    return rangeOfString("://") != nil
  }
  
  func trimedString() -> String {
    return stringByReplacingOccurrencesOfString(" ", withString: kEmptyString)
  }
  
  func urlForm() -> String {
    return !isUrlString() ? kBaseUrl.stringByAppendingString(self) : self;
  }
  
  func url() -> NSURL {
    return NSURL(string: trimedString().urlForm())!
  }
  
  func jsonObject() -> [String: AnyObject] {
    var parameter = [String: AnyObject]()
    if let query = componentsSeparatedByString("?").last {
      let components = query.componentsSeparatedByString("&")
      for component in components {
        if let key = component.componentsSeparatedByString("=").first {
          parameter[key] = component.componentsSeparatedByString("=").last?.stringByRemovingPercentEncoding
        }
      }
    }
    return parameter
  }
}