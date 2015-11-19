
import UIKit

let kSimpleProductColumn = 2

class SimpleProductView: UIView {
  @IBOutlet weak var imageView: LazyLoadingImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var originalPriceLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  var productId: Int?
  
  func configureView(product: Product?) {
    if let product = product {
      imageView.setLazyLoaingImage(product.mainImageUrl)
      nameLabel.text = product.title
      priceLabel.text = product.actualPrice?.priceNotation(.English)
      summaryLabel.text = product.subtitle
      productId = product.id
      
      originalPriceLabel.attributedText = product.originalPriceAttributedString()
    }
  }
  
  @IBAction func orderButtonTapped() {
    if let productId = productId {
      NSNotificationCenter.defaultCenter().postNotificationName(kNotificationSegueToOption,
        object: nil,
        userInfo: [kNotificationKeyProductId: productId])
    }
  }
}
