
import UIKit

class Addresses: BaseListModel {
 
  override func getUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId {
      return "users/\(userId)/delivery-destinations"
    }
    return "users/delivery-destinations"
  }
  
  override func assignObject(data: AnyObject?) {
    if let addresses = data as? [[String: AnyObject]] {
      list.removeAll()
      for addressObject in addresses {
        let address = Address()
        address.assignObject(addressObject)
        list.appendObject(address)
      }
    }
  }
  
  func recentAddress() -> Address? {
    for address in list as! [Address] {
      if address.isRecent {
        list.removeObject(address)
        total -= 1 // remove recent address from address list
        return address
      }
    }
    return nil
  }
}
