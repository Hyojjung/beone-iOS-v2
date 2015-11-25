
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
  @IBOutlet weak var selectedQuantityLabel: UILabel!
  @IBOutlet weak var quantitySelectButton: UIButton!
  
  func configureCell(productOrderableInfo: ProductOrderableInfo?, quantity: Int) {
    selectedDeliveryNameLabel.text = productOrderableInfo == nil ?
      NSLocalizedString("select delivery type", comment: "picker title") : productOrderableInfo?.name
    selectedQuantityLabel.text = "\(quantity)"
    quantitySelectButton.enabled = productOrderableInfo != nil
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