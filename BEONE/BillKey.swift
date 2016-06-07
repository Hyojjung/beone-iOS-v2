
import UIKit

enum BillKeyType: String {
  case Personal = "person"
  case Corporation = "corporate"
}

let kCentury21 = 2000

#if DEBUG

let encryptionKey = "DunOKBEzosaDNwZVZqAqfIAKm2HjA3St"

#else

let encryptionKey = "lsx8tL9CzhlcgSrdq5n2RMetKbgzTIK8"

#endif


class BillKey: BaseModel {

  var desc: String?
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
  
  override func assignObject(data: AnyObject?) {
    if let billKey = data as? [String: AnyObject] {
      id = billKey[kObjectPropertyKeyId] as? Int
      cardNumber = billKey["cardNumber"] as? String
      cardCompanyName = billKey["cardCompanyName"] as? String
      if let cardType = billKey["cardType"] as? String, billKeyType = BillKeyType(rawValue: cardType) {
        self.type = billKeyType
      }
      if let desc = billKey[kObjectPropertyKeyDescription] as? String {
        self.desc = desc
      } else if let createdAt = billKey["createdAt"] as? String,
        createdAtString = createdAt.date()?.briefDateString() {
          self.desc = "\(createdAtString) 등록"
      }
    }
  }
  
  override func postParameter() -> AnyObject? {
    var parameter = [String: AnyObject]()
    parameter["cardNumber"] = encriptedString(cardNumber!)
    parameter["idNumber"] = encriptedString(idNumber!)
    if let desc = desc {
      parameter[kObjectPropertyKeyDescription] = encriptedString(desc)
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
