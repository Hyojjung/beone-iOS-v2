
import UIKit

class TemplateListViewController: BaseTableViewController {
  
  // MARK: - Property
  
  var templateList = TemplateList()
  var templates = [Template]()
  
  // MARK: - BaseViewController Methods
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLayoutChange",
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
            newTmplate.content.models?.append(product)
            if index < (template.content.models?.count)! - 1 {
              newTmplate.content.models?.append(template.content.models![index + 1] as! Product)
            }
            templates.append(newTmplate)
          }
        }
      } else if template.type == .ProductSingle {
        for product in template.content.models as! [Product] {
          let newTmplate = Template(type: .ProductSingle)
          newTmplate.content.models?.append(product)
          templates.append(newTmplate)
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
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? TemplateCell {
      cell.configureCell(templates[indexPath.row])
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? TemplateCell {
      return cell.calculatedHeight(templates[indexPath.row])
    }
    return nil
  }
}

// MARK: - Observer Actions

extension TemplateListViewController {
  func handleLayoutChange() {
    tableView.reloadData()
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
