
import UIKit

class BaseTableViewController: BaseViewController {

  // MARK: - Property
  
  var dynamicHeightTableViewCells = [String: UITableViewCell]()
  @IBOutlet weak var tableView: DynamicHeightTableView!
  
  // MARK: - DynamicHeightTableViewProtocol

  func configure(cell: UITableViewCell, indexPath: NSIndexPath, forCalculateHeight: Bool = false) {
    cell.selectionStyle = .None
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if let tableView = tableView as? DynamicHeightTableView {
      return tableView.heightForBasicCell(indexPath)
    }
    return 0
  }
}
