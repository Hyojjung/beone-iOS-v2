
import UIKit

class OrdersViewController: BaseTableViewController {
  
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
    if let order = orderList.list[sender.tag] as? Order, orderId = order.id,
      paymentInfoId = order.paymentInfoList.mainPaymentInfo?.id {
      paymentButtonTapped(orderId, paymentInfoId: paymentInfoId)
    }
  }
}

extension OrdersViewController: AddintionalPaymentDelegate {
  
  func paymentButtonTapped(orderId: Int, paymentInfoId: Int) {
    
  }
}

extension OrdersViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return OrdersTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? OrderCell, order = orderList.list[indexPath.row] as? Order {
      cell.configureCell(order, row: indexPath.row, addintionalPaymentDelegate: self)
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
        if let order = orderList.list[indexPath.row] as? Order {
          return 180 + CGFloat(order.paymentInfoList.list.count - 1) * 100
        }
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
  @IBOutlet weak var paymentsView: UIView!
  
  func configureCell(order: Order, row: Int, addintionalPaymentDelegate: AddintionalPaymentDelegate) {
    createdAtLabel.text = order.createdAt?.briefDateString()
    orderCodeLabel.text = order.orderCode
    orderTitleLabel.text = order.title
    orderPriceLabel.text = order.actualPrice.priceNotation(.Korean)
    let orderableItem = order.orderableItemSets.first?.orderableItems.first
    orderImageView.setLazyLoaingImage(orderableItem?.productImageUrl)
    layoutPaymentsView(order.paymentInfoList.list as! [PaymentInfo],
      addintionalPaymentDelegate: addintionalPaymentDelegate)
    
    orderButton.tag = row
    orderDetailButton.tag = row
  }
  
  private func layoutPaymentsView(paymentInfos: [PaymentInfo], addintionalPaymentDelegate: AddintionalPaymentDelegate) {
    paymentsView.subviews.forEach { $0.removeFromSuperview() }
    var previousView: UIView? = nil
    for (index, paymentInfo) in paymentInfos.enumerate() {
      if !paymentInfo.isMainPayment {
        let paymentInfoView = UIView.loadFromNibName("AdditionalPaymentView") as! AdditionalPaymentView
        paymentInfoView.addintionalPaymentDelegate = addintionalPaymentDelegate
        paymentInfoView.configureView(paymentInfo)
        paymentsView.addSubViewAndEnableAutoLayout(paymentInfoView)
        paymentsView.addLeadingLayout(paymentInfoView)
        paymentsView.addTrailingLayout(paymentInfoView)
        if index == 1 {
          paymentsView.addTopLayout(paymentInfoView)
        } else if let previousView = previousView {
          paymentsView.addVerticalLayout(previousView, bottomView: paymentInfoView)
        }
        if index == paymentInfos.count - 1 {
          paymentsView.addBottomLayout(paymentInfoView)
        }
        previousView = paymentInfoView
      }
    }
  }
}