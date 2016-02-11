
import UIKit

class LandingViewController: BaseTableViewController {
  
  // MARK: - Property
  
  var templateList = TemplateList()
  
  // MARK: - BaseViewController
  
  override func setUpData() {
    super.setUpData()
    templateList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(templateList, selector: "fetch",
      name: kNotificationGuestAuthenticationSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLayoutChange",
      name: kNotificationContentsViewLayouted, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleAction:",
      name: kNotificationDoAction, object: nil)
  }
  
  @IBAction func showSpeedOrder() {
    showViewController("SpeedOrder", viewIdentifier: "SpeedOrderView")
  }
}

// MARK: - UITableViewDataSource

extension LandingViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return templateList.filterdTemplates.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension LandingViewController: DynamicHeightTableViewProtocol {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if let cellIdentifier = templateList.filterdTemplates[indexPath.row].type?.cellIdentifier() {
      return cellIdentifier
    }
    fatalError("invalid template type")
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? TemplateCell {
      cell.configureCell(templateList.filterdTemplates[indexPath.row])
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? TemplateCell {
      return cell.calculatedHeight(templateList.filterdTemplates[indexPath.row])
    }
    return nil
  }
}

// MARK: - Observer Actions

extension LandingViewController {
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
