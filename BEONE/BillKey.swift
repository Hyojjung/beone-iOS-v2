
import UIKit

enum BillKeyType: Int {
  case Personal
  case Corporation
}

let kCentury21 = 2000

#if DEBUG

let encryptionKey = "DunOKBEzosaDNwZVZqAqfIAKm2HjA3St"

#else

let encryptionKey = "lsx8tL9CzhlcgSrdq5n2RMetKbgzTIK8"

#endif


class BillKey: BaseModel {

  var name: String?
  var cardNumber: String?
  var expiredMonth = 1
  var expiredYear = NSDate().year()
  var cardPassword: String?
  var idNumber: String?
  var password: String?
  var cardCompanyName: String?
  var type = BillKeyType.Personal
  
  override func postUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/bill-key-infos"
    }
    return "users/:userId/bill-key-infos"
  }
  
  override func deleteUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/bill-key-infos/\(id!)"
    }
    return "users/:userId/bill-key-infos"
  }
  
  override func assignObject(data: AnyObject) {
    if let data = data as? [String: AnyObject] {
      id = data[kObjectPropertyKeyId] as? Int
      cardNumber = data["cardNumber"] as? String
      cardCompanyName = data["cardCompanyName"] as? String
      if let cardType = data["cardType"] as? Int, billKeyType = BillKeyType(rawValue: cardType) {
        self.type = billKeyType
      }
      if let name = data["description"] as? String {
        self.name = name
      } else if let createdAt = data["createdAt"] as? String,
        createdAtString = createdAt.date()?.briefDateString() {
          self.name = "\(createdAtString) 등록"
      }
    }
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["cardNumber"] = encriptedString(cardNumber!)
    parameter["idNumber"] = encriptedString(idNumber!)
    if let name = name {
      parameter["description"] = encriptedString(name)
    }
    if let password = password {
      parameter["cardPassword"] = encriptedString(password)
    }
    let expiredYear = self.expiredYear - kCentury21
    parameter["expiredYear"] = encriptedString("\(expiredYear)")
    parameter["expiredMonth"] = encriptedString(expiredMonthString())
    return parameter
  }
  
  func expiredMonthString() -> String {
    if expiredMonth < 10 {
      return "0\(expiredMonth)"
    } else {
      return "\(expiredMonth)"
    }
  }
  
  private func encriptedString(string: String) -> String {
    let cipherData = string.dataUsingEncoding(4)?.AES256EncryptWithKey(encryptionKey)
    return cipherData!.base64EncodedString()
  }
}
