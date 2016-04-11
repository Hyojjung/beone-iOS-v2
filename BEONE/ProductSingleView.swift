 
import UIKit
 
let kSimpleProductColumn = 2
 
class ProductCoupleView: UIView {
  
  @IBOutlet weak var imageView: LazyLoadingImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var originalPriceLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  weak var delegate: BaseViewController?
  var productId: Int?
  
  func configureView(product: Product?) {
    if let product = product {
      imageView.setLazyLoaingImage(product.mainImageUrl)
      nameLabel.text = product.title
      priceLabel.text = product.actualPrice.priceNotation(.English)
      originalPriceLabel.attributedText = product.priceAttributedString()
      summaryLabel.text = product.subtitle
      favoriteButton.selected = product.isFavorite()
      productId = product.id
    }
  }
  
  @IBAction func orderButtonTapped() {
    delegate?.showOptionView(productId, rightOrdering: true)
  }
  
  @IBAction func productButtonTapped() {
    delegate?.showProductView(productId)
  }
  
  @IBAction func favoriteButtonTapped(sender: UIButton) {
    if sender.selected == false {
      FavoriteProductHelper.postFavoriteProduct(productId, success: {
        sender.selected = true
      })
    } else {
      FavoriteProductHelper.deleteFavoriteProduct(productId, success: {
        sender.selected = false
      })
    }
  }
}
