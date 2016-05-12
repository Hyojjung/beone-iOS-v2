
import UIKit

enum DiscountWay: Int {
  case None
  case Point
  case Coupon
}

class SelectingPaymentTypeViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SelectingPaymentTypeTableViewSection: Int {
    case OrderTitle
    case OrderOrderableItem
    case DiscountInfoTitle
    case DiscountWay
    case Discount
    case PriceTitle
    case Price
    case PaymentTypes
    case Button
    case Count
  }
  
  private let kSelectingPaymentTypeTableViewCellIdentifiers = [
    "orderTitleCell",
    "orderOrderableItemCell",
    "discountInfoTitleCell",
    "discountWayCell",
    "discountSection",
    "priceTitleCell",
    "priceCell",
    "paymentTypeCell",
    "buttonCell"]
  
  private let kDiscountWaySelections = ["선택안함", "포인트", "쿠폰"]
  
  // MARK: - variable
  
  var discountWay = DiscountWay.None
  var order = Order()
  var orderPrice = 0
  var paymentTypes: PaymentTypes?
  var selectedPaymentTypeId: Int?
  var selectedCoupon: Coupon?
  var point = 0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    needOftenUpdate = false
  }
  
  override func setUpView() {
    super.setUpView()
    title = "결제수단선택"
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    var pair = [Int: AvailableTimeRange]()
    for orderableItemSet in order.orderableItemSets {
      for orderableItem in orderableItemSet.orderableItems.list as! [OrderableItem] {
        if let cartItemId = orderableItem.cartItemId {
          if order.cartItemIds.contains(cartItemId) {
            pair[cartItemId] = orderableItemSet.selectedTimeRange
          }
        }
      }
    }
    OrderHelper.fetchOrderableInfo(order) { 
      for orderableItemSet in self.order.orderableItemSets {
        for orderableItem in orderableItemSet.orderableItems.list as! [OrderableItem] {
          if let cartItemId = orderableItem.cartItemId {
            if let timeRange = pair[cartItemId] {
              orderableItemSet.selectedTimeRange = timeRange
            } else if orderableItemSet.deliveryType.isReservable && orderableItemSet.isExpressAvailable {
              orderableItemSet.isExpressReservation = true
            }
          }
        }
      }
      self.orderPrice = self.order.actualPrice
      self.tableView.reloadData()
    }
    OrderHelper.fetchPaymentTypes(cartItemIds: order.cartItemIds) {(paymentTypes) -> Void in
      self.paymentTypes = paymentTypes
      self.tableView.reloadData()
    }
  }
}

extension SelectingPaymentTypeViewController {
  
  @IBAction func orderButtonTapped() {
    if order.price == order.discountPrice {
      order.post({ (result) -> Void in
        if let result = result, data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
          self.order.assignObject(data)
          for paymentInfo in self.order.paymentInfos.list as! [PaymentInfo] {
            if paymentInfo.isMainPayment {
              paymentInfo.paymentType.id = 1001
              paymentInfo.post({ (_) -> Void in
                self.showOrderResultView(self.order, paymentInfoId: paymentInfo.id!)
                }, postFailure: { (_) -> Void in
                  self.showOrderResultView(orderResult: [kOrderResultKeyStatus: OrderResultType.Failure.rawValue])
              })
            }
          }
        }
        
        }, postFailure: { (_) -> Void in
          self.showOrderResultView(orderResult: [kOrderResultKeyStatus: OrderResultType.Failure.rawValue])
      })
    } else if let paymentTypeId = selectedPaymentTypeId, paymentTypes = paymentTypes {
      order.post({ (result) -> Void in
        if let result = result, data = result[kNetworkResponseKeyData] as? [String: AnyObject] {
          self.order.assignObject(data)
          if paymentTypeId == PaymentTypeId.Card.rawValue {
            self.showBillKeysView(self.order, paymentInfoId: (self.order.paymentInfos.mainPaymentInfo?.id)!)
            
          } else if let selectedPaymentType = paymentTypes.model(paymentTypeId) as? PaymentType {
            if selectedPaymentType.isWebViewTransaction {
              self.showOrderWebView(self.order,
                paymentTypeId: selectedPaymentType.id!,
                paymentTypeName: selectedPaymentType.name,
                paymentInfoId: self.order.paymentInfos.mainPaymentInfo?.id)
            }
          }
        }
        
        }, postFailure: { (_) -> Void in
          self.showOrderResultView(orderResult: [kOrderResultKeyStatus: OrderResultType.Failure.rawValue])
      })
    } else {
      showAlertView("결제 수단을 선택해주세요.")
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
      } else if point > orderPrice {
        showAlertView(NSLocalizedString("use less than total price", comment: "alert title"))
      } else if orderPrice - point < 1000 && orderPrice - point > 0 {
        showAlertView("결제금액은 1000원 이상이어야 합니다.")
      } else {
        self.setUpPrices(point)
      }
    }
  }
  
  @IBAction func showSelectingCouponViewButtonTapped() {
    let orderCouponsViewController = OrderCouponsViewController(nibName: "OrderCouponsViewController", bundle: nil)
    orderCouponsViewController.order = order
    orderCouponsViewController.delegate = self
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
                        if discountWay == .None {
                          self.setUpPrices()
                        } else if discountWay == .Point {
                          self.setUpPrices(self.point)
                          MyInfo.sharedMyInfo().get({
                            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0,
                              inSection: SelectingPaymentTypeTableViewSection.Discount.rawValue)],
                              withRowAnimation: .Automatic)
                          })
                        } else if discountWay == .Coupon {
                          self.setUpPrices(coupon: self.selectedCoupon)
                        }
                      }
    })
  }
  
  private func setUpPrices(point: Int? = nil, coupon: Coupon? = nil) {
    var couponIds = [Int]()
    if let couponId = coupon?.id {
      couponIds.appendObject(couponId)
    }
    
    OrderHelper.fetchCalculatedPrice(order.actualPrice, couponIds: couponIds, point: point, getSuccess: { (actualPrice, discountPrice) -> Void in
      self.order.discountPrice = discountPrice
      self.order.usedPoint = point
      self.order.usedCoupon = coupon
      self.tableView.reloadData()
    })
  }
}

extension SelectingPaymentTypeViewController: CouponDelegate {
  func selectCouponButtonTapped(coupon: Coupon) {
    selectedCoupon = coupon
    setUpPrices(coupon: coupon)
  }
  
  func deleteCouponButtonTapped() {
    selectedCoupon = nil
    setUpPrices()
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
    } else if section == SelectingPaymentTypeTableViewSection.PaymentTypes.rawValue &&
      order.price == order.discountPrice {
      return 0
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension SelectingPaymentTypeViewController: DynamicHeightTableViewDelegate {
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
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? PaymentTypeCell, paymentTypes = paymentTypes?.list as? [PaymentType] {
      cell.configureCell(paymentTypes, selectedPaymentTypeId: selectedPaymentTypeId, delegate: self)
    } else if let cell = cell as? OrderPriceCell {
      cell.configureCell(order, discountWay: discountWay)
    } else if let cell = cell as? DiscountWayCell {
      cell.configureCell(kDiscountWaySelections[discountWay.rawValue])
    } else if let cell = cell as? PointCell {
      cell.configureCell(point)
    } else if let cell = cell as? OrderOrderableItemCell {
      let cartItemId = order.cartItemIds[indexPath.row]
      for orderableItemSet in order.orderableItemSets {
        for orderableItem in orderableItemSet.orderableItems.list as! [OrderableItem] {
          if orderableItem.cartItemId == cartItemId {
            cell.configureCell(orderableItem)
            break
          }
        }
      }
    } else if let cell = cell as? CouponDiscountCell {
      cell.setUpCell(selectedCoupon)
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
  
  func configureCell(order: Order, discountWay: DiscountWay) {
    
    var deliveryPrice = 0
    for orderableItemSet in order.orderableItemSets {
      deliveryPrice += orderableItemSet.deliveryPrice
    }
    var productsPrice = 0
    for orderableItemSet in order.orderableItemSets {
      for orderableItem in orderableItemSet.orderableItems.list as! [OrderableItem] {
        productsPrice += orderableItem.actualPrice
      }
    }
    productsPriceLabel.text = productsPrice.priceNotation(.Korean)
    deliveryPriceLabel.text = deliveryPrice.priceNotation(.KoreanFreeNotation)
    
    totalPriceLabel.text = (order.price - order.discountPrice).priceNotation(.Korean)
    usedPointLabel.text = "0 원"
    usedCouponLabel.text = "0 원"
    if discountWay == .Point {
      usedPointLabel.text = order.discountPrice.priceNotation(.Korean)
    } else if discountWay == .Coupon {
      usedCouponLabel.text = order.discountPrice.priceNotation(.Korean)
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

class CouponDiscountCell: UITableViewCell {
  
  @IBOutlet weak var couponTitleLabel: UILabel!
  
  func setUpCell(coupon: Coupon?) {
    if let couponTitle = coupon?.title {
      couponTitleLabel.text = couponTitle
    } else {
      couponTitleLabel.text = NSLocalizedString("select coupon", comment: "label text")
    }
  }
}