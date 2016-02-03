
import UIKit

class NoticeViewController: BaseTableViewController {

  var noticeList = NoticeList()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    noticeList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
}

// MARK: - Actions

extension NoticeViewController {
  
  @IBAction func showNoticeButtonTapped(sender: UIButton) {
    if let notice = noticeList.list[sender.tag] as? Notice, url = notice.targetUrl {
      showWebView(url, title: notice.title)
    }
  }
}

extension NoticeViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return noticeList.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier((indexPath)), forIndexPath: indexPath)
    if let cell = cell as? NoticeCell {
      cell.configureCell(noticeList.list[indexPath.row] as! Notice, row: indexPath.row)
    }
    return cell
  }
}

extension NoticeViewController: DynamicHeightTableViewProtocol {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return "noticeCell"
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    let titleLabel = UILabel()
    titleLabel.font = UIFont.systemFontOfSize(15)
    let notice = noticeList.list[indexPath.row] as! Notice
    titleLabel.text = notice.title
    titleLabel.setWidth(ViewControllerHelper.screenWidth - 28)
    
    return CGFloat(48) + titleLabel.frame.height
  }
}

class NoticeCell: UITableViewCell {
  
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var noticeButton: UIButton!
  
  func configureCell(notice: Notice, row: Int) {
    createdAtLabel.text = notice.createdAt?.briefDateString()
    titleLabel.text = notice.title
    noticeButton.tag = row
  }
}