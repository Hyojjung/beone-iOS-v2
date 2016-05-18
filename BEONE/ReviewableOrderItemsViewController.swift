
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
  
  var orderItems = OrderItems()
  @IBOutlet weak var noReviewableItemLabel: UILabel!
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    orderItems.get { 
      self.tableView.reloadData()
      self.noReviewableItemLabel.configureAlpha(self.orderItems.total == 0)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let addingReviewViewController = segue.destinationViewController as? AddingReviewViewController,
      orderItemId = sender as? Int,
      orderItem = orderItems.model(orderItemId) as? OrderableItem {
      addingReviewViewController.review.orderItem = orderItem
    }
  }
  
  @IBAction func addReviewButtonTapped(sender: UIButton) {
    performSegueWithIdentifier("From Review Order Items To Review", sender: sender.tag)
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
  @IBOutlet weak var addReviewButton: UIButton!
  
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
    statusLabel.text = orderItem.orderDeliveryItemSet?.statusName
    
    if let orderItemId = orderItem.id {
      addReviewButton.tag = orderItemId
    }
  }
}

class ReviewableImageTitleCell: UITableViewCell {
  
  @IBOutlet weak var imageInfoLabel: UILabel!
  
  func setUpCell(reviewInfo: String?) {
    imageInfoLabel.text = reviewInfo
  }
  
  func calculatedHeight(reviewInfo: String?) -> CGFloat {
    let imageInfoLabel = UILabel()
    imageInfoLabel.font = UIFont.systemFontOfSize(14)
    imageInfoLabel.text = reviewInfo
    imageInfoLabel.setWidth(ViewControllerHelper.screenWidth - 24)
    return 51 + imageInfoLabel.frame.height
  }
}

class BaseTableViewCell: UITableViewCell {
  var height: CGFloat = 0
}
