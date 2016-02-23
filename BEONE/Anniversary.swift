
import UIKit

class Anniversary: BaseModel {
  
  var date: NSDate?
  var name: String?
  var desc: String?
  var isRecurrent = false
  
  override func assignObject(data: AnyObject?) {
    if let anniversary = data as? [String: AnyObject] {
      id = anniversary[kObjectPropertyKeyId] as? Int
      name = anniversary[kObjectPropertyKeyName] as? String
      desc = anniversary[kObjectPropertyKeyDescription] as? String
      if let date = anniversary["date"] as? String {
        self.date = date.date()
      }
      if let isRecurrent = anniversary["isRecurrent"] as? Bool {
        self.isRecurrent = isRecurrent
      }
    }
  }
  
  func leftDayString() -> String? {
    if let date = date {
      let numberOfLeftDay = abs(date.numberOfLeftDay(to: NSDate()) - 0)
      if numberOfLeftDay == 0 {
        return "오늘"
      } else if numberOfLeftDay == 1 {
        return "내일"
      } else {
        return "\(numberOfLeftDay)일 전"
      }
    }
    return nil
  }
}
