 
 class DeliveryTypeImageCell: UITableViewCell {
  @IBOutlet weak var heightConstraintView: UIView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var deliveryTypeImageView: LazyLoadingImageView!
  
  func configureCell(orderableItemSet: OrderableItemSet, needCell: Bool) {
    deliveryTypeImageView.setLazyLoaingImage(orderableItemSet.deliveryType.thumbnailImageUrl)
    heightConstraintView.changeHeightLayoutConstant(needCell ? 50 : 1)
    if needCell {
      backgroundImageView.image = UIImage(named: "pat_cart_delivery")
    } else {
      backgroundImageView.image = nil
    }
  }
 }
 
 class ShopNameCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  
  func configureCell(orderableItemSet: OrderableItemSet) {
    nameLabel.text = orderableItemSet.shop.name
  }
 }
 
 class OrderableItemCell: UITableViewCell {
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var productActualPriceLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var deliverableDateLabel: UILabel!
  @IBOutlet weak var deliveryPriceLabel: UILabel!
  @IBOutlet weak var ProductTotalPriceLabel: UILabel!
  @IBOutlet weak var selectButton: UIButton!
  @IBOutlet weak var optionModifyButton: UIButton!
  @IBOutlet weak var productButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var reselectButton: UIButton!
  @IBOutlet weak var optionSoldOutView: UIView!
  @IBOutlet weak var deliveryDatesKeyView: UIView!
  @IBOutlet weak var deliveryDatesLabelBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var directOrderButton: UIButton!
  
  func configureCell(orderableItem: OrderableItem, selectedCartItemIds: [Int]) {
    productImageView.setLazyLoaingImage(orderableItem.product.mainImageUrl)
    productNameLabel.text = orderableItem.product.title
    productPriceLabel.attributedText = orderableItem.product.priceAttributedString()
    deliveryPriceLabel.text = orderableItem.productOrderableInfo.price?.priceNotation(.KoreanFreeNotation)
    productActualPriceLabel.text = orderableItem.product.actualPrice?.priceNotation(.Korean)
    
    if let quantity = orderableItem.quantity {
      quantityLabel.text = "\(quantity)"
    } else {
      quantityLabel.text = "0"
    }
    if let price = orderableItem.price, quantity = orderableItem.quantity {
      let productTotalPrice = price * quantity
      ProductTotalPriceLabel.text = productTotalPrice.priceNotation(.Korean)
    }
    
    configureAvailableDeliveryDatesView(orderableItem)
    
    selectButton.selected = false
    for cartItemId in selectedCartItemIds {
      if cartItemId == orderableItem.cartItemId {
        selectButton.selected = true
        break
      }
    }
    if let cartItemId = orderableItem.cartItemId {
      configureButtonTag(cartItemId)
    }
    optionSoldOutView.alpha = orderableItem.product.isSoldOut() ? 1.0 : 0.0
  }
  
  private func configureAvailableDeliveryDatesView(orderableItem: OrderableItem) {
    let availableDeliveryDatesString = orderableItem.availableDeliveryDatesString()
    deliverableDateLabel.text = availableDeliveryDatesString
    deliveryDatesKeyView.alpha = availableDeliveryDatesString.isEmpty ? 0 : 1
    deliveryDatesLabelBottomConstraint.constant = availableDeliveryDatesString.isEmpty ? 0 : 7
  }
  
  private func configureButtonTag(cartItemId: Int) {
    selectButton.tag = cartItemId
    optionModifyButton.tag = cartItemId
    productButton.tag = cartItemId
    deleteButton.tag = cartItemId
    reselectButton.tag = cartItemId
    directOrderButton.tag = cartItemId
  }
 }
 
 class OrderPriceCell: UITableViewCell {
  @IBOutlet weak var totalItemPriceLabel: UILabel!
  @IBOutlet weak var totalDeliveryPriceLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  
  func configureCell(order: Order) {
    var totalItemPrice = 0
    var totalDeliveryPrice = 0
    for orderableItemSet in order.orderableItemSets {
      for orderableItem in orderableItemSet.orderableItems {
        if let quantity = orderableItem.quantity, price = orderableItem.price {
          totalItemPrice += quantity * price
        }
      }
      if let deliveryPrice = orderableItemSet.deliveryPrice {
        totalDeliveryPrice += deliveryPrice
      }
    }
    
    totalDeliveryPriceLabel.text = totalDeliveryPrice.priceNotation(.KoreanFreeNotation)
    totalItemPriceLabel.text = totalItemPrice.priceNotation(.Korean)
    totalPriceLabel.text = order.price?.priceNotation(.Korean)
  }
 }
