 
import UIKit
 
let kSimpleProductColumn = 2
 
class ProductCoupleView: UIView {
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
      priceLabel.text = product.actualPrice.priceNotation(.English)
      originalPriceLabel.attributedText = product.priceAttributedString()
      summaryLabel.text = product.subtitle
      productId = product.id
    }
  }
  
  @IBAction func orderButtonTapped() {
    if let productId = productId {
      postNotification(kNotificationSegueToOption, userInfo: [kNotificationKeyProductId: productId])
    }
  }
}