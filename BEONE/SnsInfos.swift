
import UIKit

class SnsInfos: BaseListModel {
  
  override func getUrl() -> String {
    if MyInfo.sharedMyInfo().isUser() {
      return "users/\(MyInfo.sharedMyInfo().userId!)/sns-infos"
    }
    return "sns-infos"
  }
  
  override func assignObject(data: AnyObject?) {
    if let data = data as? [[String: AnyObject]] {
      list.removeAll()
      for snsInfoObject in data {
        let snsInfo = SnsInfo()
        snsInfo.assignObject(snsInfoObject)
        list.append(snsInfo)
      }
    }
  }
  
  func isConnected(snsType: SnsType) -> Bool {
    for snsInfo in list as! [SnsInfo] {
      if snsInfo.type == snsType {
        return true
      }
    }
    return false
  }
  
  func snsInfo(snsType: SnsType) -> SnsInfo? {
    for snsInfo in list as! [SnsInfo] {
      if snsInfo.type == snsType {
        return snsInfo
      }
    }
    return nil
  }
}
