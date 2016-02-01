
import UIKit

class QuickSelectProductView: UIView {
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var saleView: UIView!
  @IBOutlet weak var discountPercentLabel: UILabel!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productSubTitleLabel: UILabel!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var productOriginalPriceLabel: UILabel!
  @IBOutlet weak var priceHorizontalIntervalLayoutConstraint: NSLayoutConstraint!

  func layoutView(product: Product) {
    productImageView.setLazyLoaingImage(product.mainImageUrl)
    saleView.alpha = product.onSale ? 1 : 0
    if let discountPercent = product.discountPercent {
      discountPercentLabel.text = "\(discountPercent)%"
    }
    productPriceLabel.text = product.actualPrice.priceNotation(.English)
    productNameLabel.text = product.title
    productSubTitleLabel.text = product.subtitle
    productOriginalPriceLabel.attributedText = product.priceAttributedString()
    priceHorizontalIntervalLayoutConstraint.constant = product.onSale ? 8 : 0
  }
}
