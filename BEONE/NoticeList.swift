
import UIKit

class NoticeList: BaseListModel {
  override func getUrl() -> String {
    return "notices"
  }
  
  override func assignObject(data: AnyObject?) {
    if let notices = data as? [[String: AnyObject]] {
      list.removeAll()
      for noticeObject in notices {
        let notice = Notice()
        notice.assignObject(noticeObject)
        list.appendObject(notice)
      }
    }
  }
}
