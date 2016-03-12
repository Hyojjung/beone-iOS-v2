
import UIKit

class AddressList: BaseListModel {
  override func getUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId {
      return "users/\(userId)/delivery-destinations"
    }
    return "users/delivery-destinations"
  }
  
  override func assignObject(data: AnyObject?) {
    if let addressList = data as? [[String: AnyObject]] {
      list.removeAll()
      for addressObject in addressList {
        let address = Address()
        address.assignObject(addressObject)
        list.appendObject(address)
      }
    }
  }
}
