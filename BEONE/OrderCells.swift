
import UIKit

class ImageCell: UITableViewCell {
  
  private let kImageViewBaseTag = 100
  
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var descriptionLabelTopLayoutConstraint: NSLayoutConstraint!
  
  func configureCell(orderItem: OrderableItem, receiverName: String!) {
    productNameLabel.text = orderItem.productTitle
    descriptionLabel.text = "'\(orderItem.shopName!)'에서 남겨주신 \(receiverName)님께 배송된\n실제 상품 사진입니다."
    for (index, itemImage) in orderItem.itemImageUrls.enumerate() {
      if let imageView = viewWithTag(index + kImageViewBaseTag) as? LazyLoadingImageView {
        imageView.setLazyLoaingImage(itemImage)
      }
    }
    
    for i in kOrderItemCellRowImageCount..<(kOrderItemCellRowImageCount * kOrderItemCellColumnImageCount) {
      if let imageView = viewWithTag(i + kImageViewBaseTag) {
        imageView.configureAlpha(orderItem.itemImageUrls.count >= kOrderItemCellRowImageCount)
      }
    }
    
    var constant = kDescriptionLabelImageViewInterval
    if orderItem.itemImageUrls.count >= kOrderItemCellRowImageCount {
      let interval = kImageViewInterval * (CGFloat(kOrderItemCellRowImageCount) - 1)
      constant += (ViewControllerHelper.screenWidth - kImageViewHorizontalInterval - interval) / CGFloat(kOrderItemCellRowImageCount)
      constant += kImageViewInterval
    }
    descriptionLabelTopLayoutConstraint.constant = constant
  }
}

class AccountInfoCell: UITableViewCell {
  
  @IBOutlet weak var dueDateLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var accountIssureLabel: UILabel!
  @IBOutlet weak var bankLabel: UILabel!
  @IBOutlet weak var accountNumberLabel: UILabel!
  
  func configureCell(paymentInfo: PaymentInfo) {
    dueDateLabel.text = paymentInfo.vbankExpiredAt?.paidAtDateString()
    priceLabel.text = paymentInfo.actualPrice.priceNotation(.Korean)
    accountIssureLabel.text = paymentInfo.vbankIssuerName
    bankLabel.text = paymentInfo.vbankIssuerBankName
    accountNumberLabel.text = paymentInfo.vbankIssuerAccount
  }
}

class OrderItemCell: UITableViewCell {
  
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var productTitleLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var qauntityLabel: UILabel!
  @IBOutlet weak var optionLabel: UILabel!
  @IBOutlet weak var optionKeyLabel: UILabel!
  
  func configureCell(orderItem: OrderableItem) {
    productImageView.setLazyLoaingImage(orderItem.productImageUrl)
    productTitleLabel.text = orderItem.productTitle
    productPriceLabel.text = orderItem.productPrice?.priceNotation(.Korean)
    qauntityLabel.text = "\(orderItem.quantity)"
    let optionString = orderItem.selectedOption?.optionString()
    optionLabel.text = optionString
    optionKeyLabel.configureAlpha(optionString != nil && !optionString!.isEmpty)
  }
}

class OrderItemSetInfoCell: UITableViewCell {
  
  @IBOutlet weak var deliveryStatusLabel: UILabel!
  @IBOutlet weak var deliveryInfoButton: UIButton!
  @IBOutlet weak var deliveryPriceLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var deliveryDateLabel: UILabel! // TODO
  @IBOutlet weak var deliveryTrackingButton: UIButton!
  @IBOutlet weak var orderDoneButton: UIButton!
  @IBOutlet weak var deliveryTrackingInfoTrailingLayoutConstraint: NSLayoutConstraint!
  
  func configureCell(orderItemSet: OrderableItemSet) {
    deliveryStatusLabel.text = orderItemSet.statusName
    deliveryPriceLabel.text = orderItemSet.deliveryPrice.priceNotation(.Korean)
    totalPriceLabel.text = orderItemSet.actualPrice.priceNotation(.Korean)
    
    deliveryInfoButton.setTitle(orderItemSet.orderDeliveryInfo.deliveryTrackingUrl, forState: .Normal)
    deliveryInfoButton.setTitle(orderItemSet.orderDeliveryInfo.deliveryTrackingUrl, forState: .Highlighted)
    
    deliveryTrackingButton.configureAlpha(orderItemSet.orderDeliveryInfo.deliveryTrackingUrl != nil)
    
    deliveryTrackingInfoTrailingLayoutConstraint.constant = orderItemSet.isCompletable ? 102 : 14
    
    orderDoneButton.configureAlpha(orderItemSet.isCompletable)
    
    if let orderItemSetId = orderItemSet.id {
      deliveryInfoButton.tag = orderItemSetId
      deliveryTrackingButton.tag = orderItemSetId
      orderDoneButton.tag = orderItemSetId
    }
  }
}

class OrdererInfoCell: UITableViewCell {
  
  @IBOutlet weak var ordererNameLabel: UILabel!
  @IBOutlet weak var ordererPhoneLabel: UILabel!
  
  func configureCell(order: Order) {
    ordererNameLabel.text = order.senderName
    ordererPhoneLabel.text = order.senderPhone
  }
}

class AddressInfoCell: UITableViewCell {
  
  @IBOutlet weak var receiverNameLabel: UILabel!
  @IBOutlet weak var receiverPhoneLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var deliveryMemoKeyLabel: UILabel!
  @IBOutlet weak var deliveryMemoLabel: UILabel!
  @IBOutlet weak var deliveryMemoKeyLabelBottomLayoutConstraint: NSLayoutConstraint!
  
  func configureCell(order: Order) {
    receiverNameLabel.text = order.address.receiverName
    receiverPhoneLabel.text = order.address.receiverPhone
    addressLabel.text = order.address.fullAddressString()
    deliveryMemoLabel.text = order.deliveryMemo
    
    if order.deliveryMemo == nil  {
      deliveryMemoKeyLabel.text = nil
    }
    deliveryMemoKeyLabelBottomLayoutConstraint.constant = order.deliveryMemo == nil ? 9 : 23
  }
}

class OrderItemSetShopNameCell: UITableViewCell {
  
  @IBOutlet weak var shopNameLabel: UILabel!
  
  func configureCell(orderItemSet: OrderableItemSet) {
    shopNameLabel.text = orderItemSet.shop.name
  }
}

class PaymentInfoCell: UITableViewCell {
  
  @IBOutlet weak var typeNameLabel: UILabel!
  @IBOutlet weak var paidAtLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  @IBOutlet weak var payButton: UIButton!
  
  func configureCell(paymentInfo: PaymentInfo) {
    if let paymentName = paymentInfo.paymentType.name {
      typeNameLabel.text = paymentName
    } else {
      typeNameLabel.text = "미결제"
    }
    if let paidAt = paymentInfo.paidAt?.paidAtDateString() {
      paidAtLabel.text = paidAt
    } else {
      paidAtLabel.text = "미결제"
    }
    totalPriceLabel.text = paymentInfo.actualPrice.priceNotation(.Korean)
    
    let buttonString = paymentInfo.actionButtonString()
    payButton.setTitle(buttonString, forState: .Normal)
    payButton.setTitle(buttonString, forState: .Highlighted)
    payButton.configureAlpha(buttonString != nil)
    payButton.tag = paymentInfo.id!
  }
}