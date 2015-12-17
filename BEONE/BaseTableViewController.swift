
import UIKit

class BaseTableViewController: BaseViewController {

  // MARK: - Property
  
  var dynamicHeightTableViewCells = [String: UITableViewCell]()
  @IBOutlet weak var tableView: DynamicHeightTableView!
  
  // MARK: - DynamicHeightTableViewProtocol

  func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    cell.selectionStyle = .None
  }
}
