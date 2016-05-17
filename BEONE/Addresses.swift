
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
  
  func removeRecentAddress() {
    var recentAddressIndex: Int?
    for (index, address) in (list as! [Address]).enumerate() {
      if address.isRecent {
        recentAddressIndex = index
      }
    }
    if let recentAddressIndex = recentAddressIndex {
      list.removeAtIndex(recentAddressIndex)
      total -= 1
    }
  }
}
