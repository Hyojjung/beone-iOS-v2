
import UIKit

class SelectingPaymentTypeViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SelectingPaymentTypeTableViewSection: Int {
    case DiscountInfoTitle
    case DiscountWay
    case Discount
    case PriceTitle
    case Price
    case PaymentTypes
    case Count
  }
  
  private let kSelectingPaymentTypeTableViewCellIdentifiers = [
    "discountInfoTitleCell",
    "discountWayCell",
    "discountSection",
    "priceTitleCell",
    "priceCell",
    "paymentTypeCell"]
  
  // MARK: - variable
  
  var order = Order()
  var paymentTypes: [PaymentType]?
  var selectedPaymentTypeId: Int?
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    OrderHelper.fetchPaymentTypeList() {(paymentTypes) -> Void in
      self.paymentTypes = paymentTypes
      self.tableView.reloadData()
    }
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlePostOrderSuccess",
      name: kNotificationPostOrderSuccess, object: nil)
    
  }
  
  func handlePostOrderSuccess() {
    performSegueWithIdentifier("From Order To Order Web", sender: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    if let orderWebViewController = segue.destinationViewController as? OrderWebViewController {
      orderWebViewController.order = order
      orderWebViewController.paymentTypeId = selectedPaymentTypeId
    }
  }
  
  @IBAction func orderButtonTapped() {
    if let paymentTypeId = selectedPaymentTypeId, paymentTypes = paymentTypes {
      var selectedPaymentType: PaymentType?
      for paymentType in paymentTypes {
        if paymentTypeId == paymentType.id {
          selectedPaymentType = paymentType
          break
        }
      }
      if let selectedPaymentType = selectedPaymentType {
        if selectedPaymentType.isWebViewTransaction {
          order.post()
        }
      }
    }
  }
}

extension SelectingPaymentTypeViewController: PaymentTypesViewDelegate {
  func selectPaymentTypeButtonTapped(paymentTypeId: Int) {
    selectedPaymentTypeId = paymentTypeId
    tableView.reloadData()
  }
}

extension SelectingPaymentTypeViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SelectingPaymentTypeTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension SelectingPaymentTypeViewController: DynamicHeightTableViewProtocol {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    switch SelectingPaymentTypeTableViewSection(rawValue: indexPath.section)! {
    case .Discount:
      return "nothingCell"
    case .PaymentTypes:
      return "paymentTypeCell"
    case .Price:
      return "priceCell"
    default:
      return kSelectingPaymentTypeTableViewCellIdentifiers[indexPath.section]
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? PaymentTypeCell, paymentTypes = paymentTypes {
      cell.configureCell(paymentTypes, selectedPaymentTypeId: selectedPaymentTypeId, delegate: self)
    } else if let cell = cell as? OrderPriceCell {
      cell.configureCell(order)
    }
  }
}

class PaymentTypeCell: UITableViewCell {
  
  @IBOutlet weak var paymentTypeView: UIView!
  
  func configureCell(paymentTypes: [PaymentType], selectedPaymentTypeId: Int?, delegate: PaymentTypesViewDelegate?) {
    paymentTypeView.subviews.forEach { $0.removeFromSuperview() }
    
    let paymentTypesView = PaymentTypesView()
    paymentTypesView.delegate = delegate
    paymentTypesView.layoutView(paymentTypes, selectedPaymentTypeId: selectedPaymentTypeId)
    paymentTypeView.addSubViewAndEdgeLayout(paymentTypesView)
  }
}

class OrderPriceCell: UITableViewCell {
  
  @IBOutlet weak var productsPriceLabel: UILabel!
  @IBOutlet weak var deliveryPriceLabel: UILabel!
  @IBOutlet weak var usedPointLabel: UILabel!
  @IBOutlet weak var usedCouponLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  
  func configureCell(order: Order) {
//    print(order.usedPoint)
//    print(order.price)
//    print(order.actualPrice)
//    print(order.discountPrice)
    var deliveryPrice = 0
    for orderableItemSet in order.orderableItemSets {
      deliveryPrice += orderableItemSet.deliveryPrice
    }
//    let productsPrice = order.price - deliveryPrice
//    let usedCoupon = order.discountPrice - order.usedPoint
    
  }
}