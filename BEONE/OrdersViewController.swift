
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
  
  // MARK: - Variable
  
  let orders = Orders()
  let reviewableOrderItems = OrderItems()
  
  var orderToOperate: Order?
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    if let orderViewController = segue.destinationViewController as? OrderViewController, orderId = sender as? Int {
      orderViewController.order.id = orderId
    }
  }
  
  override func setUpView() {
    super.setUpView()
    title = "주문/배송내역"
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    orders.get {
      self.tableView.reloadData()
    }
    reviewableOrderItems.get {
      self.tableView.reloadData()
    }
  }
}

extension OrdersViewController {
  
  @IBAction func showReviewsViewButtonTapped() {
    performSegueWithIdentifier("From Orders To Reviews", sender: nil)
  }
  
  @IBAction func showOrderDetailButtonTapped(sender: UIButton) {
    performSegueWithIdentifier("From Orders To Order Detail", sender: orders.list[sender.tag].id)
  }
  
  @IBAction func orderActionButtonTapped(sender: UIButton) {
    if let order = orders.list[sender.tag] as? Order, orderId = order.id,
      paymentInfoId = order.paymentInfos.mainPaymentInfo?.id {
      paymentButtonTapped(orderId, paymentInfoId: paymentInfoId)
    }
  }
  
  @IBAction func showHelpsViewButtonTapped() {
    showViewController(.Help)
  }
}

extension OrdersViewController: SchemeDelegate {
  
  func handleScheme(with id: Int) {
    performSegueWithIdentifier("From Orders To Order Detail", sender: id)
  }
}

extension OrdersViewController: AddintionalPaymentDelegate {
  
  func paymentButtonTapped(orderId: Int, paymentInfoId: Int) {
    
    if let order = orders.model(orderId) as? Order {
      orderToOperate = order
      
      if orderToOperate!.transactionButtonType == .Payment {
        if let paymentInfo = order.paymentInfos.model(paymentInfoId) as? PaymentInfo {
          OrderHelper.fetchPaymentTypes(order.id) {(paymentTypes) -> Void in
            self.showPayment(paymentTypes.list as? [PaymentType],
                             order: order,
                             paymentInfoId: paymentInfo.id!)
          }
        }
        
      } else if orderToOperate!.transactionButtonType == .Cancel {
        let confirmAction = Action()
        confirmAction.type = .Method
        confirmAction.content = "cancelOrder"
        
        showAlertView(NSLocalizedString("sure order cancel", comment: "alert"),
                      hasCancel: true,
                      confirmAction: confirmAction,
                      cancelAction: nil,
                      delegate: self)
      }
    }
  }
  
  func cancelOrder() {
    orderToOperate?.put({ (_) in
      self.setUpData()
    });
  }
}

extension OrdersViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return OrdersTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? OrderCell, order = orders.list[indexPath.row] as? Order {
      cell.configureCell(order, row: indexPath.row, addintionalPaymentDelegate: self)
    } else if let cell = cell as? OrdersViewReviewTitleCell {
      cell.setUpCell(reviewableOrderItems.list.count != 0)
    } else if let cell = cell as? OrdersViewTopCell {
      cell.setUpCell(orders.total, reviewableOrderItemsCount: reviewableOrderItems.total)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == OrdersTableViewSection.Order.rawValue {
      return orders.list.count
    }
    return 1
  }
}

extension OrdersViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kOrdersTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let section = OrdersTableViewSection(rawValue: indexPath.section) {
      switch (section) {
      case .Top:
        return 130
      case .Order:
        if let order = orders.list[indexPath.row] as? Order {
          return 180 + CGFloat(order.paymentInfos.list.count - 1) * 100
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
  @IBOutlet weak var orderButton: PaymentButton!
  @IBOutlet weak var orderDetailButton: UIButton!
  @IBOutlet weak var paymentsView: UIView!
  
  func configureCell(order: Order, row: Int, addintionalPaymentDelegate: AddintionalPaymentDelegate) {
    createdAtLabel.text = order.createdAt?.briefDateString()
    orderCodeLabel.text = order.orderCode
    orderTitleLabel.text = order.title
    orderPriceLabel.text = order.actualPrice.priceNotation(.Korean)
    let orderableItem = order.orderableItemSets.first?.orderableItems.list.first as? OrderableItem
    orderImageView.setLazyLoaingImage(orderableItem?.productImageUrl)
    orderImageView.makeCircleView()
    layoutPaymentsView(order.paymentInfos.list as! [PaymentInfo],
                       addintionalPaymentDelegate: addintionalPaymentDelegate)
    
    orderButton.setUp(order.transactionButtonType, isOrder: true)
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

class OrdersViewReviewTitleCell: UITableViewCell {
  
  @IBOutlet weak var newReviewImageView: UIImageView!
  
  func setUpCell(hasNew: Bool) {
    newReviewImageView.configureAlpha(hasNew)
  }
}

class OrdersViewTopCell: UITableViewCell {
  
  @IBOutlet weak var totalOrdersCountLabel: UILabel!
  @IBOutlet weak var reviewableOrderItemsCountLabel: UILabel!
  
  func setUpCell(totalOrdersCount: Int, reviewableOrderItemsCount: Int) {
    totalOrdersCountLabel.text = "\(totalOrdersCount)"
    reviewableOrderItemsCountLabel.text = "\(reviewableOrderItemsCount)"
  }
}