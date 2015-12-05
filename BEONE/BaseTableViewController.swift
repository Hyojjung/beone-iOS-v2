
import UIKit

class BaseTableViewController: BaseViewController {

  // MARK: - Property
  
  @IBOutlet weak var tableView: UITableView!

  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.estimatedRowHeight = kTableViewDefaultHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
}
