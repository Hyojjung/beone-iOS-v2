
import UIKit

class BaseTableViewController: BaseViewController, UITableViewDelegate {

  // MARK: - Property
  
  @IBOutlet weak var tableView: DynamicHeightTableView!
  
  // MARK: - DynamicHeightTableViewProtocol

  func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    cell.selectionStyle = .None
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if let tableView = tableView as? DynamicHeightTableView {
      return tableView.heightForBasicCell(indexPath)
    }
    return 0
  }
}
