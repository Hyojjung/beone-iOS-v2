
import UIKit

protocol ProductDelegate: NSObjectProtocol {
  func productOrderButtonTapped(productId: Int)
  func productButtonTapped(productId: Int)
}

class SpeedOrderProductView: UIView {
  
  weak var delegate: ProductDelegate?
  
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var saleView: UIView!
  @IBOutlet weak var discountPercentLabel: UILabel!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productSubTitleLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var productOriginalPriceLabel: UILabel!
  @IBOutlet weak var priceHorizontalIntervalLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var productButton: UIButton!
  @IBOutlet weak var productOrderButton: UIButton!

  func layoutView(product: Product) {
    productImageView.setLazyLoaingImage(product.mainImageUrl)
    saleView.configureAlpha(product.onSale)
    if let discountPercent = product.discountPercent {
      discountPercentLabel.text = "\(discountPercent)%"
    }
    productPriceLabel.text = product.actualPrice.priceNotation(.English)
    productNameLabel.text = product.title
    productSubTitleLabel.text = product.subtitle
    productOriginalPriceLabel.attributedText = product.priceAttributedString()
    priceHorizontalIntervalLayoutConstraint.constant = product.onSale ? 8 : 0
    
    if let productId = product.id {
      productButton.tag = productId
      productOrderButton.tag = productId
    }
  }
  
  @IBAction func productOrderButtonTapped(sender: UIButton) {
    delegate?.productOrderButtonTapped(sender.tag)
  }
  
  @IBAction func productButtonTapped(sender: UIButton) {
    delegate?.productButtonTapped(sender.tag)
  }
}
