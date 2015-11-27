
import UIKit

class AddressList: BaseListModel {
  override func fetchUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId {
      return "users/\(userId)/delivery-infos"
    }
    return "users/delivery-infos"
  }
  
  override func assignObject(data: AnyObject) {
    if let addressList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      list.removeAll()
      for addressObject in addressList {
        let address = Address()
        address.assignObject(addressObject)
        list.append(address)
      }
      postNotification(kNotificationFetchAddressListSuccess)
    }
  }
}
