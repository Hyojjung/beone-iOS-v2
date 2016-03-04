
import UIKit

class ReviewableOrderItemsViewController: BaseTableViewController {

  // MARK: - Constant
  
  private enum ReviewableOrderItemsTableViewSection: Int {
    case Top
    case ReviewableOrderItem
  }
  
  private let kReviewableOrderItemsTableViewCellIdentifiers = [
    "topCell",
    "reviewableOrderItemCell"]
  
  // MARK: - Variable
  
  var orderItems = OrderItemList()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    orderItems.get { () -> Void in
      self.tableView.reloadData()
    }
  }
}

extension ReviewableOrderItemsViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if orderItems.list.isEmpty {
      return 0
    }
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return orderItems.list.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? ReviewableOrderItemCell {
      cell.setUpCell(orderItems.list[indexPath.row] as! OrderableItem)
    }
    return cell
  }
}

extension ReviewableOrderItemsViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kReviewableOrderItemsTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if indexPath.section == ReviewableOrderItemsTableViewSection.Top.rawValue {
      let topLabel = UILabel()
      topLabel.font = UIFont.systemFontOfSize(13)
      topLabel.text = NSLocalizedString("reviews view top cell label", comment: "top cell label")
      topLabel.setWidth(ViewControllerHelper.screenWidth - 28)
      print(topLabel.frame.height)
      return 80 + topLabel.frame.height
    } else if let cell = cell as? BaseTableViewCell {
      return cell.height
    }
    return 0
  }
}

class ReviewableOrderItemCell: BaseTableViewCell {
  
  @IBOutlet weak var orderItemImageView: LazyLoadingImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    height = 315
  }
  
  func setUpCell(orderItem: OrderableItem) {
    orderItemImageView.setLazyLoaingImage(orderItem
    .productImageUrl)
    titleLabel.text = orderItem.productTitle
    subtitleLabel.text = orderItem.productSubtitle
    quantityLabel.text = "\(orderItem.quantity)"
    statusLabel.text = orderItem.orderStatus
  }
}

class BaseTableViewCell: UITableViewCell {
  var height: CGFloat = 0
}
