
import UIKit

let kOrderItemCellRowImageCount = 4
let kOrderItemCellColumnImageCount = 2
let kDescriptionLabelImageViewInterval = CGFloat(17)
let kImageViewInterval = CGFloat(6)
let kImageViewHorizontalInterval = CGFloat(28)

class OrderViewController: BaseTableViewController {
  
  // MARK: - Constants
  
  private enum OrderTableViewSection: Int {
    case ImageTitle
    case Image
    case AccountInfo
    case Shop
    case OrdererInfo
    case AddressInfo
    case PaymentInfo
    case Buttons
    case Count
  }
  
  private let kOrderTableViewCellIdentifiers = [
    "imageTitleCell",
    "imageCell",
    "accountInfoCell",
    "shopCell",
    "ordererInfoCell",
    "addressInfoCell",
    "paymentInfoCell",
    "buttonCell"]
  
  // MARK: - Variables
  
  var order = Order()
  var orderItemsWithImages = [OrderableItem]()
  var bankUnpaiedPaymentInfos = [PaymentInfo]()
  var returnableOrderItemSets = [OrderableItemSet]()
  var paymentTypes: PaymentTypes?
  var paymentInfoToOperate: PaymentInfo?
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    order.get { 
      self.setUpOrder()
      self.tableView.reloadData()
    }
    OrderHelper.fetchPaymentTypes(order.id) {(paymentTypes) -> Void in
      self.paymentTypes = paymentTypes
    }
  }
}

// MARK: - Private Methods

extension OrderViewController {
  
  private func setUpOrder() {
    setUpOrderItemsWithImages()
    setUpBankUnpaiedPaymentInfos()
    setUpReturnableOrderItemSets()
  }
  
  private func setUpReturnableOrderItemSets() {
    returnableOrderItemSets.removeAll()
    for orderableItemSet in order.orderableItemSets {
      if orderableItemSet.isReturnable {
        returnableOrderItemSets.appendObject(orderableItemSet)
      }
    }
  }
  
  private func setUpOrderItemsWithImages() {
    orderItemsWithImages.removeAll()
    for orderableItemSet in order.orderableItemSets {
      for orderItem in orderableItemSet.orderableItems.list as! [OrderableItem] {
        if !orderItem.itemImageUrls.isEmpty {
          orderItemsWithImages.appendObject(orderItem)
        }
      }
    }
  }
  
  private func setUpBankUnpaiedPaymentInfos() {
    bankUnpaiedPaymentInfos.removeAll()
    for paymentInfo in order.paymentInfos.list as! [PaymentInfo] {
      if paymentInfo.paidAt == nil && paymentInfo.paymentType.id == PaymentTypeId.VBank.rawValue {
        bankUnpaiedPaymentInfos.appendObject(paymentInfo)
      }
    }
  }
}

// MARK: - TableView Helper Methods

extension OrderViewController {
  
  private func orderItem(indexPath: NSIndexPath) -> OrderableItem? {
    let sectionType = self.sectionType(indexPath.section)
    if sectionType == .Image {
      return orderItemsWithImages[indexPath.row]
    } else if sectionType == .Shop {
      let orderItemSet = order.orderableItemSets[indexPath.section - OrderTableViewSection.Shop.rawValue]
      return orderItemSet.orderableItems.list[indexPath.row - 1] as? OrderableItem
    }
    return nil
  }
  
  private func orderItemSet(section: Int) -> OrderableItemSet {
    return order.orderableItemSets[section - OrderTableViewSection.Shop.rawValue]
  }
  
  private func sectionType(section: Int) -> OrderTableViewSection {
    if section >= OrderTableViewSection.Shop.rawValue &&
      section < order.orderableItemSets.count + OrderTableViewSection.Shop.rawValue {
        return .Shop
    } else if section <= OrderTableViewSection.AccountInfo.rawValue {
      return OrderTableViewSection(rawValue: section)!
    } else {
      return OrderTableViewSection(rawValue: section - order.orderableItemSets.count + 1)!
    }
  }
}

// MARK: - Actions

extension OrderViewController {
  
  @IBAction func paymentButtonTapped(sender: UIButton) {
    if let paymentInfo = order.paymentInfos.model(sender.tag) as? PaymentInfo {
      paymentInfoToOperate = paymentInfo;
      
      if paymentInfo.transactionButtonType == .Payment {
        showPayment(paymentTypes?.list as? [PaymentType],
                    order: order,
                    paymentInfoId: paymentInfo.id!)
      } else if paymentInfo.transactionButtonType == .Cancel {
        let confirmAction = Action()
        confirmAction.type = .Method
        confirmAction.content = "cancelOrder"
        
        showAlertView(NSLocalizedString("sure order cancel", comment: "alert"), hasCancel: true, confirmAction: confirmAction, cancelAction: nil, delegate: self)
      }
    }
  }
  
  @IBAction func deliveryTrackingInfoButtonTapped(sender: UIButton) {
    for orderItemSet in order.orderableItemSets {
      if orderItemSet.id == sender.tag {
        showWebView(orderItemSet.orderDeliveryInfo.deliveryTrackingUrl, title: "배송조회")
        break
      }
    }
  }
  
  func cancelOrder() {
    // 결제가 메인 결제이면, 주문 자체가 취소
    // 아닌 경우, 한 결제만 취소
    if let paymentInfo = paymentInfoToOperate{
      if paymentInfo.isMainPayment {
        order.put({ (_) -> Void in
          self.popView()
        })
        
      } else {
        paymentInfoToOperate?.put({ (_) -> Void in
          self.setUpData()
        })
      }
      
    }
  }
}

extension OrderViewController: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return order.orderableItemSets.count + OrderTableViewSection.Count.rawValue - 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionType = self.sectionType(section)
    if sectionType == .ImageTitle && orderItemsWithImages.count == 0 {
      return 0
    } else if sectionType == .Image {
      return orderItemsWithImages.count
    } else if sectionType == .AccountInfo {
      return bankUnpaiedPaymentInfos.count
    } else if sectionType == .Shop {
      return orderItemSet(section).orderableItems.list.count + 2
    } else if sectionType == .PaymentInfo {
      return order.paymentInfos.list.count
    } else if sectionType == .Buttons && returnableOrderItemSets.isEmpty {
      return 0
    }
    return 1
  }
}

extension OrderViewController: SchemeDelegate {
  
  func handleScheme(with id: Int) {
    order.id = id
    setUpData()
    SchemeHelper.schemeStrings.removeAtIndex(0)
    handleScheme()
  }
}

extension OrderViewController: DynamicHeightTableViewDelegate {
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? ImageCell, orderItem = self.orderItem(indexPath) {
      cell.configureCell(orderItem, receiverName: order.address.receiverName!)
    } else if let cell = cell as? OrderItemCell, orderItem = self.orderItem(indexPath) {
      cell.configureCell(orderItem)
    } else if let cell = cell as? OrderItemSetInfoCell {
      cell.configureCell(orderItemSet(indexPath.section))
    } else if let cell = cell as? OrdererInfoCell {
      cell.configureCell(order)
    } else if let cell = cell as? AddressInfoCell {
      cell.configureCell(order)
    } else if let cell = cell as? PaymentInfoCell {
      cell.configureCell(order.paymentInfos.list[indexPath.row] as! PaymentInfo, order: order)
    } else if let cell = cell as? OrderItemSetShopNameCell {
      cell.configureCell(orderItemSet(indexPath.section))
    } else if let cell = cell as? AccountInfoCell {
      cell.configureCell(bankUnpaiedPaymentInfos[indexPath.row])
    }
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    let section = self.sectionType(indexPath.section)
    if section == .Shop {
      if indexPath.row == 0 {
        return "shopNameCell"
      } else if indexPath.row == orderItemSet(indexPath.section).orderableItems.list.count + 1 {
        return "orderItemSetInfoCell"
      } else {
        return "orderItemCell"
      }
    } else {
      return kOrderTableViewCellIdentifiers[section.rawValue]
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    let sectionType = self.sectionType(indexPath.section)
    switch (sectionType) {
    case .ImageTitle:
      return 43
    case .Image:
      if let orderItem = self.orderItem(indexPath) {
        return calculatedImageCellHeight(orderItem)
      }
    case .AccountInfo:
      return 204
    case .Shop:
      if let _ = cell as? OrderItemCell, orderItem = self.orderItem(indexPath) {
        return calculatedOrderItemCellHeight(orderItem)
      } else if indexPath.row == 0 {
        return 44
      } else {
        return 132
      }
    case .OrdererInfo:
      return 130
    case .PaymentInfo:
      return 148
    case .Buttons:
      return 65
    case .Count, .AddressInfo: break
    }
    return nil
  }
  
  func calculatedImageCellHeight(orderItem: OrderableItem) -> CGFloat {
    let interval = kImageViewInterval * (CGFloat(kOrderItemCellRowImageCount) - 1)
    let defaultHeight = CGFloat(122)
    var imageViewHeight = (ViewControllerHelper.screenWidth - kImageViewHorizontalInterval - interval) / CGFloat(kOrderItemCellRowImageCount)
    if orderItem.itemImageUrls.count >= kOrderItemCellRowImageCount {
      imageViewHeight *= CGFloat(kOrderItemCellColumnImageCount)
      imageViewHeight += kImageViewInterval
    }
    return defaultHeight + imageViewHeight
  }
  
  func calculatedOrderItemCellHeight(orderItem: OrderableItem) -> CGFloat {
    let optionLabel = UILabel()
    optionLabel.font = UIFont.systemFontOfSize(12)
    optionLabel.text = orderItem.selectedOption?.optionString()
    optionLabel.setWidth(ViewControllerHelper.screenWidth - 113)
    return 152 + optionLabel.frame.height
  }
}