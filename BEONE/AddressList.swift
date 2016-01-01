
import UIKit

class AddressList: BaseListModel {
  override func fetchUrl() -> String {
    if let userId = MyInfo.sharedMyInfo().userId {
      return "users/\(userId)/delivery-destinations"
    }
    return "users/delivery-destinations"
  }
  
  override func assignObject(data: AnyObject) {
    if let addressList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      print(addressList)
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
