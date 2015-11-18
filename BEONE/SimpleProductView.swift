
import UIKit

let kSimpleProductColumn = 2

class SimpleProductView: UIView {
  @IBOutlet weak var imageView: LazyLoadingImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var originalPriceLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  
  func configureView(product: Product?) {
    if let product = product {
      imageView.setLazyLoaingImage(product.mainImageUrl)
      nameLabel.text = product.title
      priceLabel.text = product.actualPrice?.priceNotation(.English)
      
      let productPrice = product.price?.priceNotation(.None)
      if product.isOnSale && productPrice != nil {
        let originalPrice = NSMutableAttributedString(string: productPrice!)
        originalPrice.addAttribute(NSStrikethroughStyleAttributeName,
          value: NSUnderlineStyle.StyleSingle.rawValue,
          range: NSMakeRange(0, productPrice!.characters.count))
        originalPriceLabel.attributedText = originalPrice
      } else {
        originalPriceLabel.text = nil
      }
      summaryLabel.text = product.subtitle
    }
  }
}
