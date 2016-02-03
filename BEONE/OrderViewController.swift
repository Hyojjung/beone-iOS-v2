
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
  var paymentTypes: [PaymentType]?
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    order.get { () -> Void in
      self.setUpOrder()
      self.tableView.reloadData()
    }
    OrderHelper.fetchPaymentTypeList() {(paymentTypes) -> Void in
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
        returnableOrderItemSets.append(orderableItemSet)
      }
    }
  }
  
  private func setUpOrderItemsWithImages() {
    orderItemsWithImages.removeAll()
    for orderableItemSet in order.orderableItemSets {
      for orderItem in orderableItemSet.orderableItems {
        if !orderItem.itemImageUrls.isEmpty {
          orderItemsWithImages.append(orderItem)
        }
      }
    }
  }
  
  private func setUpBankUnpaiedPaymentInfos() {
    bankUnpaiedPaymentInfos.removeAll()
    for paymentInfo in order.paymentInfoList.list as! [PaymentInfo] {
      if paymentInfo.paidAt == nil && paymentInfo.paymentType.id == PaymentTypeId.VBank.rawValue {
        bankUnpaiedPaymentInfos.append(paymentInfo)
      }
    }
  }
}

// MARK: - TableView Helper Methods

extension OrderViewController {
  
  private func orderItem(indexPath: NSIndexPath) -> OrderableItem? {
    let section = self.section(indexPath.section)
    if section == .Image {
      return orderItemsWithImages[indexPath.row]
    } else if section == .Shop {
      let orderItemSet = order.orderableItemSets[indexPath.section - OrderTableViewSection.Shop.rawValue]
      return orderItemSet.orderableItems[indexPath.row - 1]
    }
    return nil
  }
  
  private func orderItemSet(section: Int) -> OrderableItemSet {
    return order.orderableItemSets[section - OrderTableViewSection.Shop.rawValue]
  }
  
  private func section(section: Int) -> OrderTableViewSection {
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
    showPayment(paymentTypes, order: order, paymentInfoId: sender.tag)
  }
}

extension OrderViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return order.orderableItemSets.count + OrderTableViewSection.Count.rawValue - 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? ImageCell, orderItem = self.orderItem(indexPath) {
      cell.configureCell(orderItem, receiverName: order.address.receiverName!)
    } else if let cell = cell as? OrderItemCell, orderItem = self.orderItem(indexPath) {
      cell.configureCell(orderItem)
    } else if let cell = cell as? OrderItemSerInfoCell {
      cell.configureCell(orderItemSet(indexPath.section), index: indexPath.row - 1)
    } else if let cell = cell as? OrdererInfoCell {
      cell.configureCell(order)
    } else if let cell = cell as? AddressInfoCell {
      cell.configureCell(order)
    } else if let cell = cell as? PaymentInfoCell {
      cell.configureCell(order.paymentInfoList.list[indexPath.row] as! PaymentInfo)
    } else if let cell = cell as? OrderItemSetShopNameCell {
      cell.configureCell(orderItemSet(indexPath.section))
    } else if let cell = cell as? AccountInfoCell {
      cell.configureCell(bankUnpaiedPaymentInfos[indexPath.row])
    }
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == OrderTableViewSection.ImageTitle.rawValue && orderItemsWithImages.count == 0 {
      return 0
    } else if section == OrderTableViewSection.Image.rawValue {
      return orderItemsWithImages.count
    } else if section == OrderTableViewSection.AccountInfo.rawValue {
      return bankUnpaiedPaymentInfos.count
    } else if section >= OrderTableViewSection.Shop.rawValue &&
      section < order.orderableItemSets.count + OrderTableViewSection.Shop.rawValue {
        return orderItemSet(section).orderableItems.count + 2
    } else if section == OrderTableViewSection.PaymentInfo.rawValue {
      return order.paymentInfoList.list.count
    } else if section == OrderTableViewSection.Buttons.rawValue && returnableOrderItemSets.isEmpty {
      return 0
    }
    return 1
  }
}



extension OrderViewController: DynamicHeightTableViewProtocol {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    let section = self.section(indexPath.section)
    if section == .Shop {
      if indexPath.row == 0 {
        return "shopNameCell"
      } else if indexPath.row == orderItemSet(indexPath.section).orderableItems.count + 1 {
        return "orderItemSetInfoCell"
      } else {
        return "orderItemCell"
      }
    } else {
      return kOrderTableViewCellIdentifiers[section.rawValue]
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    let section = self.section(indexPath.section)
    switch (section) {
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
    case .AddressInfo:
      return calculatedAddressInfoCellHeight()
    case .PaymentInfo:
      return 148
    case .Buttons:
      return 65
    case .Count: break
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
  
  func calculatedAddressInfoCellHeight() -> CGFloat {
    var height = CGFloat(136)
    
    let addressLabel = UILabel()
    addressLabel.font = UIFont.systemFontOfSize(12)
    addressLabel.text = order.address.fullAddressString()
    addressLabel.setWidth(ViewControllerHelper.screenWidth - 113)
    
    height += addressLabel.frame.height
    
    if let deliveryMemo = order.deliveryMemo {
      height += 8
      
      let deliveryMemoLabel = UILabel()
      deliveryMemoLabel.font = UIFont.systemFontOfSize(12)
      deliveryMemoLabel.text = deliveryMemo
      deliveryMemoLabel.setWidth(ViewControllerHelper.screenWidth - 113)
      height += deliveryMemoLabel.frame.height
    }
    
    return height
  }
}