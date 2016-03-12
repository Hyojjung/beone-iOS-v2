
import UIKit

class HelpList: BaseListModel {
  override func getUrl() -> String {
    return "helps"
  }
  
  override func assignObject(data: AnyObject?) {
    if let helps = data as? [[String: AnyObject]] {
      list.removeAll()
      for helpObject in helps {
        let help = Help()
        help.assignObject(helpObject)
        list.appendObject(help)
      }
    }
  }
}
