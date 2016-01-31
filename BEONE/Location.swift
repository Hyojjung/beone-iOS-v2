
import UIKit

private let kLocationPropertyKeyName = "name"
private let kLocationValidationPropertyKeyIsValid = "isValid"

class Location: BaseModel {
  
  var name: String?
  
  override func assignObject(data: AnyObject) {
    id = data[kObjectPropertyKeyId] as? Int
    name = data[kLocationPropertyKeyName] as? String
  }
  
  func validate(jibunAddress: String?) {
    if let jibunAddress = jibunAddress {
      NetworkHelper.requestGet("locations/\(id!)/validation",
        parameter: ["jibunAddress": jibunAddress],
        success: { (result) -> Void in
          print(result)
          if let data = result[kNetworkResponseKeyData] as? [String: AnyObject],
            isValid = data[kLocationValidationPropertyKeyIsValid] as? Bool {
              self.postNotification(kNotificationValidateAddressSuccess, userInfo: [kNotificationKeyIsValid: isValid])
          }
        }, failure: nil)
    }
  }
}
