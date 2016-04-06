
let kSectionCellCount = 2 // delivery type cell + shop cell count
 
 class DeliveryTypeCell: UITableViewCell {
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var deliveryTypeImageView: LazyLoadingImageView!
  
  func configureCell(orderableItemSet: OrderableItemSet, needCell: Bool) {
    deliveryTypeImageView.setLazyLoaingImage(orderableItemSet.deliveryType.thumbnailImageUrl)
    if needCell {
      backgroundImageView.image = UIImage(named: "pat_cart_delivery")
    } else {
      backgroundImageView.image = nil
    }
  }
  
  func calculatedHeight(needCell: Bool) -> CGFloat {
    return needCell ? 50 : 1
  }
 }
 
 class ShopNameCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  
  func configureCell(orderableItemSet: OrderableItemSet) {
    nameLabel.text = orderableItemSet.shop.name
  }
 }

class CartOrderableItemCell: OrderableItemCell {
  
  @IBOutlet weak var optionModifyButton: UIButton!
  @IBOutlet weak var productButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var reselectButton: UIButton!
  @IBOutlet weak var optionSoldOutView: UIView!
  @IBOutlet weak var deliveryDatesKeyView: UIView!
  @IBOutlet weak var minusButton: UIButton!
  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var directOrderButton: UIButton!
  @IBOutlet weak var deliverableDateLabel: UILabel!
  @IBOutlet weak var soldOutImageView: UIImageView!
  @IBOutlet weak var selectButton: UIButton!

  override func calculatedHeight(orderableItem: OrderableItem, selectedOption: ProductOptionSets?) -> CGFloat {
    var height = super.calculatedHeight(orderableItem, selectedOption: selectedOption)
    let availableDeliveryDatesString = orderableItem.availableTimeRanges.availableDeliveryDatesString()
    if !availableDeliveryDatesString.isEmpty {
      let availableDeliveryDatesLabel = UILabel()
      availableDeliveryDatesLabel.font = UIFont.systemFontOfSize(13)
      availableDeliveryDatesLabel.text = availableDeliveryDatesString
      availableDeliveryDatesLabel.setWidth(ViewControllerHelper.screenWidth - 167)
      
      height += availableDeliveryDatesLabel.frame.height + 7
    }
    return height
  }
  
  func configureCell(orderableItem: OrderableItem, selectedOption: ProductOptionSets?, selectedCartItemIds: [Int]?) {
    super.configureCell(orderableItem, selectedOption: selectedOption)
    
    selectButton?.selected = false
    if let selectedCartItemIds = selectedCartItemIds {
      for cartItemId in selectedCartItemIds {
        if cartItemId == orderableItem.cartItemId {
          selectButton?.selected = true
          break
        }
      }
    }
    if let cartItemId = orderableItem.cartItemId {
      configureButtonTag(cartItemId)
    }
    optionSoldOutView?.configureAlpha(orderableItem.product.soldOut)
    soldOutImageView.configureAlpha(orderableItem.product.soldOut)
    configureAvailableDeliveryDatesView(orderableItem)
  }
  
  private func configureAvailableDeliveryDatesView(orderableItem: OrderableItem) {
    let availableDeliveryDatesString = orderableItem.availableTimeRanges.availableDeliveryDatesString()
    deliverableDateLabel?.text = availableDeliveryDatesString
    deliveryDatesKeyView?.configureAlpha(!availableDeliveryDatesString.isEmpty)
    deliveryDatesLabelBottomConstraint?.constant = availableDeliveryDatesString.isEmpty ? 0 : 7
  }
  
  private func configureButtonTag(cartItemId: Int) {
    minusButton?.tag = cartItemId
    addButton?.tag = cartItemId
    selectButton?.tag = cartItemId
    optionModifyButton?.tag = cartItemId
    productButton?.tag = cartItemId
    deleteButton?.tag = cartItemId
    reselectButton?.tag = cartItemId
    directOrderButton?.tag = cartItemId
  }
}

 class OrderableItemCell: UITableViewCell {
  
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var productActualPriceLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var deliveryPriceLabel: UILabel!
  @IBOutlet weak var productTotalPriceLabel: UILabel!
  @IBOutlet weak var deliveryDatesLabelBottomConstraint: NSLayoutConstraint?
  @IBOutlet weak var optionKeyViewBottomConstraint: NSLayoutConstraint?
  @IBOutlet weak var optionLabel: UILabel!
  @IBOutlet weak var optionKeyView: UIView!

  func calculatedHeight(orderableItem: OrderableItem, selectedOption: ProductOptionSets?) -> CGFloat {
    var height = CGFloat(208)
    if let option = selectedOption {
      let optionLabel = UILabel()
      optionLabel.font = UIFont.systemFontOfSize(13)
      optionLabel.text = option.optionString()
      optionLabel.setWidth(ViewControllerHelper.screenWidth - 167)
      height += optionLabel.frame.height + 10
    }
    
    let productNameLabel = UILabel()
    productNameLabel.font = UIFont.systemFontOfSize(16)
    productNameLabel.text = orderableItem.product.title
    productNameLabel.setWidth(ViewControllerHelper.screenWidth - 183)
    height += productNameLabel.frame.height
    
    return height
  }
  
  func configureCell(orderableItem: OrderableItem, selectedOption: ProductOptionSets?) {
    productImageView.setLazyLoaingImage(orderableItem.product.mainImageUrl)
    productNameLabel.text = orderableItem.product.title
    productPriceLabel.attributedText = orderableItem.product.priceAttributedString()
    deliveryPriceLabel.text = orderableItem.productOrderableInfo.price?.priceNotation(.KoreanFreeNotation)
    productActualPriceLabel.text = orderableItem.product.actualPrice.priceNotation(.Korean)
    optionLabel.text = selectedOption?.optionString()
    optionKeyView.configureAlpha(selectedOption != nil && !selectedOption!.list.isEmpty)
    
    quantityLabel.text = "\(orderableItem.quantity)"
    productTotalPriceLabel.text = orderableItem.actualPrice.priceNotation(.Korean)
  }
 }
 
 class CartPriceCell: UITableViewCell {
  @IBOutlet weak var totalItemPriceLabel: UILabel!
  @IBOutlet weak var totalDeliveryPriceLabel: UILabel!
  @IBOutlet weak var totalPriceLabel: UILabel!
  
  func configureCell(order: Order) {
    let (totalItemPrice, totalDeliveryPrice) = order.prices()
    totalDeliveryPriceLabel.text = totalDeliveryPrice.priceNotation(.KoreanFreeNotation)
    totalItemPriceLabel.text = totalItemPrice.priceNotation(.Korean)
    totalPriceLabel.text = order.actualPrice.priceNotation(.Korean)
  }
 }
