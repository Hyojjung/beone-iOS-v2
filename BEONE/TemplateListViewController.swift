
import UIKit

class TemplateListViewController: BaseTableViewController {
  
  // MARK: - Property

  var templateList = TemplateList()
  
  // MARK: - BaseViewController Methods

  override func setUpView() {
    super.setUpView()
    tableView.registerNib(UINib(nibName: kTemplateTableViewCellNibName, bundle: nil),
      forCellReuseIdentifier: kTemplateTableViewCellIdentifier)
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
    if let userInfo = notification.userInfo,
      templateId = userInfo[kNotificationKeyTemplateId] as? NSNumber,
      templateHeight = userInfo[kNotificationKeyHeight] as? CGFloat {
        for (index, template) in (templateList.list as! [Template]).enumerate() {
          if template.id == templateId {
            template.height = templateHeight
            let templateIndexPath = NSIndexPath(forRow: index, inSection: 0)
            print(tableView.indexPathsForVisibleRows)
            if tableView.indexPathsForVisibleRows!.contains(templateIndexPath) {
              tableView.reloadRowsAtIndexPaths([templateIndexPath], withRowAnimation: .Automatic)
            }
            break;
          }
        }
    }
  }
  
  func handleAction(notification: NSNotification) {
    if let userInfo = notification.userInfo, templateId = userInfo[kNotificationKeyTemplateId] as? NSNumber {
      for template in templateList.list as! [Template] {
        if template.id == templateId {
//          if template.contents.count == 1 {
//            template.contents.first?.action.action()
//          } else if let contentsId = userInfo[kNotificationKeyContentsId] as? NSNumber {
//            for contents in template.contents {
//              if contents.id == contentsId {
//                contents.action.action()
//                break;
//              }
//            }
//          }
          break;
        }
      }
    }
  }
}
