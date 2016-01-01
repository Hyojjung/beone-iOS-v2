
import UIKit

class AvailableTimeRange: BaseModel {
  var endDateTime: NSDate?
  var startDateTime: NSDate?
  
  override func assignObject(data: AnyObject) {
    endDateTime = (data["endDateTime"] as? String)?.date()
    startDateTime = (data["startDateTime"] as? String)?.date()
  }
  
  func timeRangeNotation() -> String {
    var timeRangeNotation = String()
    if let startDateTime = startDateTime, endDateTime = endDateTime {
      let startHour = startDateTime.hour()
      if startHour < kNoonTime {
        timeRangeNotation += "오전 \(startHour)"
      } else if startHour == kNoonTime {
        timeRangeNotation += "오후 \(startHour)"
      } else {
        timeRangeNotation += "오후 \(startHour - kNoonTime)"
      }
      timeRangeNotation += "시 ~ "
      
      let endHour = endDateTime.hour()
      if endHour <= kNoonTime {
        timeRangeNotation += "\(endHour)시"
      } else {
        timeRangeNotation += "\(endHour - kNoonTime)시"
      }
    }
    return timeRangeNotation
  }
}
