
import UIKit

class AddingReviewViewController: BaseTableViewController {

  // MARK: - Constant
  
  private enum AddingReviewTableViewSection: Int {
    case Item
    case ImageTitle
    case Image
    case AddImageButton
    case SubmitButton
    case Count
  }
  
  private let kAddingReviewTableViewCellIdentifiers = [
    "itemCell",
    "imageTitleCell",
    "imageCell",
    "addButtonCell",
    "submitButtonCell"]
  
  private let kAddingReviewTableViewCellHeights: [CGFloat] = [
    379,
    81,
    200,
    79,
    49]
}

extension AddingReviewViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kAddingReviewTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return kAddingReviewTableViewCellHeights[indexPath.section]
  }
}

extension AddingReviewViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return AddingReviewTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath),
      forIndexPath: indexPath)
    return cell
  }
}
