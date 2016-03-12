
import UIKit

class AvailableTimeRangeList: BaseListModel {
  
  override func assignObject(data: AnyObject?) {
    if let availableTimeRangesObject = data as? [[String: AnyObject]] {
      list.removeAll()
      for availableTimeRangeObject in availableTimeRangesObject {
        let availableTimeRange = AvailableTimeRange()
        availableTimeRange.assignObject(availableTimeRangeObject)
        list.appendObject(availableTimeRange)
      }
    }
  }
  
  func availableDeliveryDates() -> [(month: Int, day: Int)] {
    var deliveryDates = [(month: Int, day: Int)]()
    for availableTimeRange in list as! [AvailableTimeRange] {
      if let (month, day) = availableTimeRange.startDateTime?.dateComponent() {
        if !deliveryDates.contains({ $0.month == month && $0.day == day }) {
          deliveryDates.appendObject((month, day))
        }
      }
    }
    return deliveryDates
  }
  
  func availableDeliveryRanges(date: NSDate) -> [AvailableTimeRange] {
    let dateComponent = date.dateComponent()
    var availableTimeRanges = [AvailableTimeRange]()
    for availableTimeRange in list as! [AvailableTimeRange] {
      if let (month, day) = availableTimeRange.startDateTime?.dateComponent() {
        if dateComponent.month == month && dateComponent.day == day {
          availableTimeRanges.appendObject(availableTimeRange)
        }
      }
    }
    return availableTimeRanges
  }
  
  func availableDeliveryDatesString() -> String {
    var deliveryDatesString = String()
    var deliveryMonthes = [Int]()
    for availableDeliveryDate in availableDeliveryDates() {
      if deliveryMonthes.contains(availableDeliveryDate.month) {
        deliveryDatesString += ", \(availableDeliveryDate.day)일"
      } else {
        deliveryMonthes.appendObject(availableDeliveryDate.month)
        deliveryDatesString += "\(availableDeliveryDate.month)월 \(availableDeliveryDate.day)일"
      }
    }
    return deliveryDatesString
  }
}
