
import UIKit

class ProductOrderableInfo: BaseModel {
  var price: Int?
  var availableDates = [NSDate]()
  var deliveryType = DeliveryType()
  
  override func assignObject(data: AnyObject) {
    if let productOrderableInfo = data as? [String: AnyObject] {
      id = productOrderableInfo[kObjectPropertyKeyId] as? Int
      price = productOrderableInfo["actualPrice"] as? Int
      if let deliveryType = productOrderableInfo["deliveryType"] as? [String: AnyObject] {
        self.deliveryType.assignObject(deliveryType)
      }
      if let availableDates = productOrderableInfo["availableDates"] as? [String] {
        self.availableDates.removeAll()
        for availableDate in availableDates {
          if let day = availableDate.day() {
            self.availableDates.append(day)
          }
        }
      }
      
    }
  }
  
  func availableDatesString() -> String {
    if availableDates.count > 0 {
      var availableDatesString = String()
      var monthes = [Int]()
      for (index, availableDate) in availableDates.enumerate() {
        let dateComponent = availableDate.dateComponent()
        if !monthes.contains(dateComponent.0) {
          if index != 0 {
            availableDatesString += "일, "
          }
          monthes.append(dateComponent.0)
          availableDatesString += "\(dateComponent.0)월 "
        } else {
          if index != 0 {
            availableDatesString += ", "
          }
        }
        availableDatesString += "\(dateComponent.1)"
      }
      availableDatesString += "일"
      return availableDatesString
    } else {
      return "희망배송일을 설정할 수 없습니다."
    }
  }
}
