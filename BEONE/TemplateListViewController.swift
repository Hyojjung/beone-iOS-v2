
import UIKit

class TemplateListViewController: BaseViewController {
  @IBOutlet weak var tableView: UITableView!

  var templateList = TemplateList()

  func handleLayoutChange(notification: NSNotification) {
    if let userInfo = notification.userInfo,
      templateId = userInfo[kNotificationKeyTemplateId] as? NSNumber,
      templateHeight = userInfo[kNotificationKeyHeight] as? CGFloat {
        for template in templateList.list as! [Template] {
          if template.id == templateId {
            template.height = templateHeight
            tableView.reloadData()
            break;
          }
        }
    }
  }
  
  func handleAction(notification: NSNotification) {
    if let userInfo = notification.userInfo, templateId = userInfo[kNotificationKeyTemplateId] as? NSNumber {
      for template in templateList.list as! [Template] {
        if template.id == templateId {
          if template.contents.count == 1 {
            template.contents.first?.action.action()
          } else if let contentsId = userInfo[kNotificationKeyContentsId] as? NSNumber {
            for contents in template.contents {
              if contents.id == contentsId {
                contents.action.action()
                break;
              }
            }
          }
          break;
        }
      }
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.estimatedRowHeight = kTableViewDefaultHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.registerNib(UINib(nibName: kNibNameTemplateTableViewCell, bundle: nil),
      forCellReuseIdentifier: kCellIdentifierTemplateTableViewCell)
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
