
class ProductCell: UITableViewCell {
  @IBOutlet weak var mainImageView: LazyLoadingImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var actualPriceLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  func configureCell(product: Product) {
    mainImageView.setLazyLoaingImage(product.mainImageUrl)
    titleLabel.text = product.title
    actualPriceLabel.text = product.actualPrice?.priceNotation(.English)
    priceLabel.attributedText = product.priceAttributedString()
  }
}

class CartItemInfoCell: UITableViewCell {
  @IBOutlet weak var selectedDeliveryNameLabel: UILabel!
  
  func configureCell(productOrderableInfo: ProductOrderableInfo?) {
    selectedDeliveryNameLabel.text = productOrderableInfo == nil ?
      NSLocalizedString("select delivery type", comment: "picker title") : productOrderableInfo?.name
  }
}

class CartItemCountCell: UITableViewCell {
  @IBOutlet weak var selectedQuantityLabel: UILabel!
  @IBOutlet weak var quantitySelectButton: UIButton!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var optionLabel: UILabel!
  
  func configureCell(cartItem: CartItem, indexPath: NSIndexPath) {
    selectedQuantityLabel.text = "\(cartItem.quantity)"
    quantitySelectButton.tag = indexPath.row
    optionLabel.text = cartItem.selectedOption?.optionString()
  }
}

class ButtonCell: UITableViewCell {
  @IBOutlet weak var addCartItemButton: UIButton!
  
  func configureCell() {
    let buttonTitle = BEONEManager.ordering ?
      NSLocalizedString("order right now", comment: "button title") :
      NSLocalizedString("add to cart", comment: "button title")
    addCartItemButton.setTitle(buttonTitle, forState: .Normal)
    addCartItemButton.setTitle(buttonTitle, forState: .Highlighted)
  }
}


class OptionCell: UITableViewCell {

  weak var delegate: AnyObject?

  @IBOutlet weak var optionView: OptionView!
  
  func configureCell(productOptionSetList: ProductOptionSetList?) {
    if let productOptionSetList = productOptionSetList {
      optionView.delegate = delegate
      optionView.layoutView(productOptionSetList)
    }
  }
}