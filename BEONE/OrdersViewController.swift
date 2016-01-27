
import UIKit

class OrdersViewController: BaseUserViewController {
  
  // MARK: - Constant
  
  private enum OrdersTableViewSection: Int {
    case Top
    case Order
    case Logo
    case Review
    case Help
    case Space
    case Count
  }
  
  private let kOrdersTableViewCellIdentifiers = [
    "topCell",
    "orderCell",
    "logoCell",
    "reviewCell",
    "helpCell",
    "spaceCell"]
  
  var orderList = OrderList()
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    if let orderViewController = segue.destinationViewController as? OrderViewController, order = sender as? Order {
      orderViewController.order = order
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    orderList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  @IBAction func showOrderDetailButtonTapped(sender: UIButton) {
    performSegueWithIdentifier("From Order List To Order Detail", sender: orderList.list[sender.tag])
  }
  
  @IBAction func orderActionButtonTapped(sender: UIButton) {
  }
}

extension OrdersViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return OrdersTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? OrderCell, order = orderList.list[indexPath.row] as? Order {
      cell.configureCell(order, row: indexPath.row)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == OrdersTableViewSection.Order.rawValue {
      return orderList.list.count
    }
    return 1
  }
}

extension OrdersViewController: DynamicHeightTableViewProtocol {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kOrdersTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let section = OrdersTableViewSection(rawValue: indexPath.section) {
      switch (section) {
      case .Top:
        return 130
      case .Order:
        return 180
      default:
        return 46
      }
    }
    return nil
  }
}

class OrderCell: UITableViewCell {
  
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var orderCodeLabel: UILabel!
  @IBOutlet weak var orderTitleLabel: UILabel!
  @IBOutlet weak var orderImageView: LazyLoadingImageView!
  @IBOutlet weak var orderPriceLabel: UILabel!
  @IBOutlet weak var orderButton: UIButton!
  @IBOutlet weak var orderDetailButton: UIButton!
  
  func configureCell(order: Order, row: Int) {
    createdAtLabel.text = order.createdAt?.briefDateString()
    orderCodeLabel.text = order.orderCode
    orderTitleLabel.text = order.title
    orderPriceLabel.text = order.actualPrice.priceNotation(.Korean)
    let orderableItem = order.orderableItemSets.first?.orderableItems.first
    orderImageView.setLazyLoaingImage(orderableItem?.productImageUrl)
    
    orderButton.tag = row
    orderDetailButton.tag = row
  }
}