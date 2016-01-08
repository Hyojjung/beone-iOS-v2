
import UIKit

class TemplateListViewController: BaseTableViewController {
  
  // MARK: - Property

  var templateList = TemplateList()
  var templates = [Template]()
  
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
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUpTemplateList",
      name: kNotificationFetchTemplateListSuccess, object: nil)
  }
  
  func setUpTemplateList() {
    templates.removeAll()
    for template in templateList.list as! [Template] {
      if template.type == .ProductCouple {
        for (index, product) in (template.content.models as! [Product]).enumerate() {
          if index % 2 == 0 {
            let newTmplate = Template(type: .ProductCouple)
            newTmplate.content.models = [Product]()
            newTmplate.content.models?.append(product)
            if index < (template.content.models?.count)! - 1 {
              newTmplate.content.models?.append(template.content.models![index + 1] as! Product)
            }
            templates.append(newTmplate)
          }
        }
      } else {
        templates.append(template)
      }
    }
    tableView.reloadData()
  }
}

extension TemplateListViewController: DynamicHeightTableViewProtocol {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if let cellIdentifier = templates[indexPath.row].type?.cellIdentifier() {
      return cellIdentifier
    }
    fatalError("invalid template type")
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath, forCalculateHeight: Bool = false) {
    if let cell = cell as? TemplateCell {
      cell.configureCell(templates[indexPath.row], forCalculateHeight: forCalculateHeight)
    }
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
