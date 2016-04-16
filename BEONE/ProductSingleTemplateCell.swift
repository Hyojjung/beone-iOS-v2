
import UIKit

class ProductSingleTemplateCell: TemplateCell {
  
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productSubTitleLabel: UILabel!
  @IBOutlet weak var discountPercentLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var originalPriceLabel: UILabel!
  @IBOutlet weak var priceLabelLeadingLayoutConstraint: NSLayoutConstraint!
  
  weak var favoriteProductDelegate: FavoriteProductDelegate?
  var productId: Int?

  override func configureCell(template: Template) {
    super.configureCell(template)
    if let products = template.content.models as? [Product] {
      if products.count > 0 {
        configureView(products.first!)
      }
    }
  }
  
  func configureView(product: Product?) {
    configureDefaulStyle()
    if let product = product {
      productImageView.setLazyLoaingImage(product.mainImageUrl)
      productNameLabel.text = product.title
      productSubTitleLabel.text = product.subtitle
      priceLabel.text = product.actualPrice.priceNotation(.English)
      originalPriceLabel.attributedText = product.priceAttributedString()
      favoriteButton.selected = product.isFavorite()
      if let discountPercent = product.discountPercent {
        discountPercentLabel.text = "\(discountPercent)%"
        priceLabelLeadingLayoutConstraint.constant = 6
      } else {
        discountPercentLabel.text = nil
        priceLabelLeadingLayoutConstraint.constant = 0
      }
      productId = product.id
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
