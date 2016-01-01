
import UIKit

class AvailableTimeRangeList: BaseListModel {
  func availableDeliveryDates() -> [(Int, Int)] {
    var deliveryDates = [(Int, Int)]()
    for availableTimeRange in list as! [AvailableTimeRange] {
      if let (month, day) = availableTimeRange.startDateTime?.dateComponent() {
        if !deliveryDates.contains({ $0.0 == month && $0.1 == day }) { // for delivery date tuple 0 : month, 1 : day
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
        if dateComponent.0 == month && dateComponent.1 == day {
          availableTimeRanges.append(availableTimeRange)
        }
      }
    }
    return availableTimeRanges
  }
}
