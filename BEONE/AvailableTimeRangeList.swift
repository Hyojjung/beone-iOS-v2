
import UIKit

class AvailableTimeRangeList: BaseListModel {
  func availableDeliveryDates() -> [(month: Int, day: Int)] {
    var deliveryDates = [(month: Int, day: Int)]()
    for availableTimeRange in list as! [AvailableTimeRange] {
      if let (month, day) = availableTimeRange.startDateTime?.dateComponent() {
        if !deliveryDates.contains({ $0.month == month && $0.day == day }) { // for delivery date tuple 0 : month, 1 : day
          deliveryDates.append((month, day))
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
          availableTimeRanges.append(availableTimeRange)
        }
      }
    }
    return availableTimeRanges
  }
}
