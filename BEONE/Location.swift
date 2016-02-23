
import UIKit

private let kLocationValidationPropertyKeyIsValid = "isValid"

class Location: BaseModel {
  
  var name: String?
  
  override func assignObject(data: AnyObject?) {
    if let location = data as? [String: AnyObject] {
      id = location[kObjectPropertyKeyId] as? Int
      name = location[kObjectPropertyKeyName] as? String
    }
  }
  
  func validate(jibunAddress: String?) {
    if let jibunAddress = jibunAddress {
      NetworkHelper.requestGet("locations/\(id!)/validation",
        parameter: ["jibunAddress": jibunAddress],
        success: { (result) -> Void in
          if let data = result[kNetworkResponseKeyData] as? [String: AnyObject],
            isValid = data[kLocationValidationPropertyKeyIsValid] as? Bool {
              self.postNotification(kNotificationValidateAddressSuccess, userInfo: [kNotificationKeyIsValid: isValid])
          }
        }, failure: nil)
    }
  }
}
