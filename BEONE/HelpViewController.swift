
import UIKit

class HelpViewController: BaseTableViewController {
  
  var helpList = HelpList()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    helpList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
}

// MARK: - Actions

extension HelpViewController {
  
  @IBAction func showHelpButtonTapped(sender: UIButton) {
    if let help = helpList.list[sender.tag] as? Help, url = help.targetUrl {
      showWebView(url, title: help.title)
    }
  }
}

extension HelpViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return helpList.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier((indexPath)), forIndexPath: indexPath)
    if let cell = cell as? HelpCell {
      cell.configureCell(helpList.list[indexPath.row] as! Help, row: indexPath.row)
    }
    return cell
  }
}

extension HelpViewController: DynamicHeightTableViewProtocol {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return "helpCell"
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    let titleLabel = UILabel()
    titleLabel.font = UIFont.systemFontOfSize(15)
    let help = helpList.list[indexPath.row] as! Help
    titleLabel.text = help.title
    titleLabel.setWidth(ViewControllerHelper.screenWidth - 80)
    
    return CGFloat(48) + titleLabel.frame.height
  }
}

class HelpCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var helpButton: UIButton!
  
  func configureCell(help: Help, row: Int) {
    titleLabel.text = help.title
    helpButton.tag = row
  }
}