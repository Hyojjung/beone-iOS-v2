
import UIKit

class AvailableTimeRange: BaseModel {
  var endDateTime: NSDate?
  var startDateTime: NSDate?
  
  override func assignObject(data: AnyObject) {
    endDateTime = (data["endDateTime"] as? String)?.date()
    startDateTime = (data["startDateTime"] as? String)?.date()
  }
}
