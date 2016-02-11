
import UIKit

enum DiscountWay: Int {
  case None
  case Point
  case Coupon
}

class SelectingPaymentTypeViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SelectingPaymentTypeTableViewSection: Int {
    case OrderOrderableItem
    case DiscountInfoTitle
    case DiscountWay
    case Discount
    case PriceTitle
    case Price
    case PaymentTypes
    case Count
  }
  
  private let kSelectingPaymentTypeTableViewCellIdentifiers = [
    "orderOrderableItemCell",
    "discountInfoTitleCell",
    "discountWayCell",
    "discountSection",
    "priceTitleCell",
    "priceCell",
    "paymentTypeCell"]
  
  private let kDiscountWaySelections = ["선택안함", "포인트", "쿠폰"]
  
  // MARK: - variable
  
  var discountWay = DiscountWay.None
  var order = Order()
  var paymentTypeList: PaymentTypeList?
  var selectedPaymentTypeId: Int?
  var point = 0
  var selectedCoupont: Coupon?
  var orderActualPrice: Int?
  var orderDiscountPrice: Int?
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    var pair = [Int: AvailableTimeRange]()
    for orderableItemSet in order.orderableItemSets {
      for orderableItem in orderableItemSet.orderableItems {
        if let cartItemId = orderableItem.cartItemId {
          if order.cartItemIds.contains(cartItemId) {
            pair[cartItemId] = orderableItemSet.selectedTimeRange
          }
        }
      }
    }
    OrderHelper.fetchOrderableInfo(order) { () -> Void in
      for orderableItemSet in self.order.orderableItemSets {
        for orderableItem in orderableItemSet.orderableItems {
          if let cartItemId = orderableItem.cartItemId {
            orderableItemSet.selectedTimeRange = pair[cartItemId]
          }
        }
      }
      self.tableView.reloadData()
    }
    OrderHelper.fetchPaymentTypeList() {(paymentTypeList) -> Void in
      self.paymentTypeList = paymentTypeList
      self.tableView.reloadData()
    }
  }
  
  @IBAction func orderButtonTapped() {
    if let paymentTypeId = selectedPaymentTypeId, paymentTypeList = paymentTypeList {
      self.order.post({ (result) -> Void in
        if let result = result, data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
          self.order.assignObject(data)
          if paymentTypeId == PaymentTypeId.Card.rawValue {
            self.showBillKeysView(self.order, paymentInfoId: (self.order.paymentInfoList.mainPaymentInfo?.id)!)
          } else if let selectedPaymentType = paymentTypeList.model(paymentTypeId) as? PaymentType {
              if selectedPaymentType.isWebViewTransaction {
                self.showOrderWebView(self.order, paymentTypeId: selectedPaymentType.id!,
                  paymentInfoId: self.order.paymentInfoList.mainPaymentInfo?.id)
            }
          }
        }
        
        }, postFailure: { (_) -> Void in
          self.showOrderResultView(orderResult: [kOrderResultKeyStatus: OrderStatus.Failure.rawValue])
      })
    }
  }
  
  @IBAction func applyPointButtonTapped() {
    endEditing()
    if let myPoint = MyInfo.sharedMyInfo().point?.integerValue {
      if myPoint < point {
        showAlertView(NSLocalizedString("too much point", comment: "alert title"))
      } else if point < 1000 {
        showAlertView(NSLocalizedString("use more than 1000 point", comment: "alert title"))
      } else if point % 100 > 1 {
        showAlertView(NSLocalizedString("use more 100 unit point", comment: "alert title"))
      } else if point > order.actualPrice {
        showAlertView(NSLocalizedString("use less than total price", comment: "alert title"))
      } else {
        OrderHelper.fetchCalculatedPrice(order.actualPrice, point: point, getSuccess: { (actualPrice, discountPrice) -> Void in
          self.orderActualPrice = actualPrice
          self.orderDiscountPrice = discountPrice
          self.tableView.reloadData()
        })
      }
    }
  }
  
  @IBAction func showSelectingCouponViewButtonTapped() {
    let orderCouponsViewController = OrderCouponsViewController()
    orderCouponsViewController.order = order
    showViewController(orderCouponsViewController, sender: nil)
  }
  
  @IBAction func selectDiscountWayButtonTapped(sender: UIButton) {
    showActionSheet(NSLocalizedString("select discount way", comment: "action sheet title"),
      rows: kDiscountWaySelections,
      initialSelection: discountWay.rawValue,
      sender: sender,
      doneBlock: { (_, index, _) -> Void in
        if let discountWay = DiscountWay(rawValue: index) {
          self.discountWay = discountWay
          self.tableView.reloadData()
        }
    })
  }
}

extension SelectingPaymentTypeViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    if let pointString = textField.text, point = Int(pointString) {
      self.point = point
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
    if section == SelectingPaymentTypeTableViewSection.OrderOrderableItem.rawValue {
      return order.cartItemIds.count
    }
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
      switch discountWay {
      case .Point:
        return "pointCell"
      case .Coupon:
        return "couponCell"
      case .None:
        return "nothingCell"
      }
    case .PaymentTypes:
      return "paymentTypeCell"
    case .Price:
      return "priceCell"
    default:
      return kSelectingPaymentTypeTableViewCellIdentifiers[indexPath.section]
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if cell is OrderOrderableItemCell {
      return 97
    } else if let cell = cell as? PaymentTypeCell, paymentTypes = paymentTypeList?.list as? [PaymentType] {
      return cell.calculatedHeight(paymentTypes)
    } else if cell.reuseIdentifier == "discountInfoTitleCell" || cell.reuseIdentifier == "priceTitleCell" {
      return 60
    } else if cell.reuseIdentifier == "discountWayCell" {
      return 58
    } else if cell.reuseIdentifier == "pointCell" {
      return 133
    } else if cell.reuseIdentifier == "couponCell" {
      return 83
    } else if cell.reuseIdentifier == "nothingCell" {
      return 22
    } else if cell.reuseIdentifier == "priceCell" {
      return 231
    }
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? PaymentTypeCell, paymentTypes = paymentTypeList?.list as? [PaymentType] {
      cell.configureCell(paymentTypes, selectedPaymentTypeId: selectedPaymentTypeId, delegate: self)
    } else if let cell = cell as? OrderPriceCell {
      cell.configureCell(order, actualPrice: orderActualPrice, discountPrice: orderDiscountPrice, discountWay: discountWay)
    } else if let cell = cell as? DiscountWayCell {
      cell.configureCell(kDiscountWaySelections[discountWay.rawValue])
    } else if let cell = cell as? PointCell {
      cell.configureCell(point)
    } else if let cell = cell as? OrderOrderableItemCell {
      let cartItemId = order.cartItemIds[indexPath.row]
      for orderableItemSet in order.orderableItemSets {
        for orderableItem in orderableItemSet.orderableItems {
          if orderableItem.cartItemId == cartItemId {
            cell.configureCell(orderableItem)
            break
          }
        }
      }
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
    return CGFloat(height)
  }
}

class OrderPriceCell: UITableViewCell {
  
  @IBOutlet weak var productsPriceLabel: UILabel!
  @IBOutlet weak var deliveryPriceLabel: UILabel!
  @IBOutlet weak var usedPointLabel: UILabel!
  @IBOutlet weak var usedCouponLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  
  func configureCell(order: Order, actualPrice: Int?, discountPrice: Int?, discountWay: DiscountWay) {
    
    var deliveryPrice = 0
    for orderableItemSet in order.orderableItemSets {
      deliveryPrice += orderableItemSet.deliveryPrice
    }
    let productsPrice = order.actualPrice - deliveryPrice
    productsPriceLabel.text = productsPrice.priceNotation(.Korean)
    deliveryPriceLabel.text = deliveryPrice.priceNotation(.KoreanFreeNotation)
    
    if let actualPrice = actualPrice {
      totalPriceLabel.text = actualPrice.priceNotation(.Korean)
    } else {
      totalPriceLabel.text = order.actualPrice.priceNotation(.Korean)
    }
    
    usedPointLabel.text = "0 원"
    usedCouponLabel.text = "0 원"
    if discountWay == .Point {
      usedPointLabel.text = discountPrice?.priceNotation(.Korean)
    } else if discountWay == .Coupon {
      usedCouponLabel.text = discountPrice?.priceNotation(.Korean)
    }
  }
}

class DiscountWayCell: UITableViewCell {
  
  @IBOutlet weak var discountWayLabel: UILabel!
  
  func configureCell(discountWayTitle: String) {
    discountWayLabel.text = discountWayTitle
  }
}

class PointCell: UITableViewCell {
  
  @IBOutlet weak var pointTextField: UITextField!
  @IBOutlet weak var myPointLabel: UILabel!
  
  func configureCell(point: Int) {
    pointTextField.text = "\(point)"
    if let point = MyInfo.sharedMyInfo().point?.integerValue.priceNotation(.None) {
      myPointLabel.text = point + " point"
    } else {
      myPointLabel.text = "0 point"
    }
  }
}