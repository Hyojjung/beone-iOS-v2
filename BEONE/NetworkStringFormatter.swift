
import UIKit

extension String {
  private func isUrlString() -> Bool {
    return rangeOfString("://") != nil
  }
  
  func trimedString() -> String {
    return stringByReplacingOccurrencesOfString(" ", withString: "")
  }
  
  private func urlForm() -> String {
    return !isUrlString() ? kBaseUrl.stringByAppendingString(self) : self;
  }
  
  func url() -> NSURL {
    return NSURL(string: trimedString().urlForm())!
  }
}