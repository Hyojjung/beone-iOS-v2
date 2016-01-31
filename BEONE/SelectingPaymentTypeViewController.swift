
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    if let orderWebViewController = segue.destinationViewController as? OrderWebViewController {
      orderWebViewController.order = order
      orderWebViewController.paymentInfoId = order.mainPaymentInfo?.id
      orderWebViewController.paymentTypeId = selectedPaymentTypeId
    }
  }
  
  @IBAction func orderButtonTapped() {
    if let paymentTypeId = selectedPaymentTypeId, paymentTypes = paymentTypes {
      var selectedPaymentType: PaymentType?
      if selectedPaymentTypeId == PaymentTypeId.Card.rawValue {
        performSegueWithIdentifier("From Order To Billing", sender: nil)
      }
      for paymentType in paymentTypes {
        if paymentTypeId == paymentType.id {
          selectedPaymentType = paymentType
          break
        }
      }
      if let selectedPaymentType = selectedPaymentType {
        if selectedPaymentType.isWebViewTransaction {
          order.post({ (result) -> Void in
            if let result = result as? [String: AnyObject], data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
              self.order.assignObject(data)
              self.performSegueWithIdentifier("From Order To Order Web", sender: nil)
            }
          })
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
    if let cell = cell as? PaymentTypeCell, paymentTypes = paymentTypes {
      return cell.calculatedHeight(paymentTypes)
    }
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
  
  func calculatedHeight(paymentTypes: [PaymentType]) -> CGFloat {
    let height = 104 + paymentTypes.count * Int(kPaymentTypeButtonHeight) + (paymentTypes.count - 1) * Int(kPaymentTypeButtonInterval)
    print(height)
    return CGFloat(height)
  }
}

class OrderPriceCell: UITableViewCell {
  
  @IBOutlet weak var productsPriceLabel: UILabel!
  @IBOutlet weak var deliveryPriceLabel: UILabel!
  @IBOutlet weak var usedPointLabel: UILabel!
  @IBOutlet weak var usedCouponLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  
  func configureCell(order: Order) {
    var deliveryPrice = 0
    for orderableItemSet in order.orderableItemSets {
      deliveryPrice += orderableItemSet.deliveryPrice
    }
    let productsPrice = order.price - deliveryPrice
    let usedCoupon = order.discountPrice - order.usedPoint
    productsPriceLabel.text = productsPrice.priceNotation(.Korean)
    deliveryPriceLabel.text = deliveryPrice.priceNotation(.KoreanFreeNotation)
    usedPointLabel.text = order.usedPoint.priceNotation(.Korean)
    usedCouponLabel.text = usedCoupon.priceNotation(.Korean)
    totalPriceLabel.text = order.actualPrice.priceNotation(.Korean)
    
  }
}