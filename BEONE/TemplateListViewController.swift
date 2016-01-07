
import UIKit

class TemplateListViewController: BaseTableViewController {
  
  // MARK: - Property

  var templateList = TemplateList()
  
  // MARK: - BaseViewController Methods

  override func setUpView() {
    super.setUpView()
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLayoutChange:",
      name: kNotificationContentsViewLayouted, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleAction:",
      name: kNotificationDoAction, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(tableView, selector: "reloadData",
      name: kNotificationFetchTemplateListSuccess, object: nil)
  }
}

// MARK: - Observer Actions 

extension TemplateListViewController {
  func handleLayoutChange(notification: NSNotification) {
    tableView.reloadData()
//    if let userInfo = notification.userInfo,
//      templateId = userInfo[kNotificationKeyTemplateId] as? NSNumber {
//        for (index, template) in (templateList.list as! [Template]).enumerate() {
//          if template.id == templateId {
//            tableView.reloadData()
//            break;
//          }
//        }
//    }
  }
  
  func handleAction(notification: NSNotification) {
    if let userInfo = notification.userInfo, templateId = userInfo[kNotificationKeyTemplateId] as? NSNumber {
      for template in templateList.list as! [Template] {
        if template.id == templateId {
          break;
        }
      }
    }
  }
}
