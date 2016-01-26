
import UIKit

enum BillKeyType: Int {
  case Personal = 1
  case Corporation
}

let kCentury21 = 2000

class BillKey: BaseModel {

  var name: String?
  var cardNumber: String?
  var expiredMonth = 1
  var expiredYear = NSDate().year() - kCentury21
  var cardPassword: String?
  var idNumber: String?
  var cardCompanyName: String?
  var billKeyType = BillKeyType.Personal
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      print(data)
      id = data[kObjectPropertyKeyId] as? Int
      cardNumber = data["cardNumber"] as? String
      cardCompanyName = data["cardCompanyName"] as? String
      if let cardType = data["cardType"] as? Int, billKeyType = BillKeyType(rawValue: cardType) {
        self.billKeyType = billKeyType
      }
      if let name = data["description"] as? String {
        self.name = name
      } else if let createdAt = data["createdAt"] as? String,
        createdAtString = createdAt.date()?.briefDateString() {
          self.name = "\(createdAtString) 등록"
      }
    }
  }
}
