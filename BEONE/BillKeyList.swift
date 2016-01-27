
import UIKit

class BillKeyList: BaseListModel {

  override func fetchUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/bill-key-infos"
    }
    return "bill-key-infos"
  }
  
  override func assignObject(data: AnyObject) {
    if let billKeys = data as? [[String: AnyObject]] {
      list.removeAll()
      for billKeyObject in billKeys {
        let billKey = BillKey()
        billKey.assignObject(billKeyObject)
        list.append(billKey)
      }
    }
  }
}
