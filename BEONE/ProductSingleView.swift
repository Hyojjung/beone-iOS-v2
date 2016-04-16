 
import UIKit
 
let kSimpleProductColumn = 2
 
 protocol FavoriteProductDelegate: NSObjectProtocol {
  func toggleFavoriteProduct(sender: UIView, productId: Int, isFavorite: Bool)
 }
 
class ProductCoupleView: UIView {
  
  @IBOutlet weak var imageView: LazyLoadingImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var originalPriceLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  
  weak var favoriteProductDelegate: FavoriteProductDelegate?
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
    if let productId = productId {
      SchemeHelper.setUpScheme("/option/\(productId)")
    }
  }
  
  @IBAction func productButtonTapped() {
    if let productId = productId {
      SchemeHelper.setUpScheme("/product/\(productId)")
    }
  }
  
  @IBAction func favoriteButtonTapped(sender: UIButton) {
    if sender.selected == false {
      FavoriteProductHelper.postFavoriteProduct(productId, success: {
        sender.selected = true
        self.favoriteProductDelegate?.toggleFavoriteProduct(self, productId: self.productId!, isFavorite: sender.selected)
      })
    } else {
      FavoriteProductHelper.deleteFavoriteProduct(productId, success: {
        sender.selected = false
        self.favoriteProductDelegate?.toggleFavoriteProduct(self, productId: self.productId!, isFavorite: sender.selected)
      })
    }
  }
}
