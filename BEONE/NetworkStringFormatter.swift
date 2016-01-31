
import UIKit

extension String {
  private func isUrlString() -> Bool {
    return rangeOfString("://") != nil
  }
  
  func trimedString() -> String {
    return stringByReplacingOccurrencesOfString(" ", withString: "")
  }
  
  func urlForm() -> String {
    return !isUrlString() ? kBaseUrl.stringByAppendingString(self) : self;
  }
  
  func url() -> NSURL {
    return NSURL(string: trimedString().urlForm())!
  }
}