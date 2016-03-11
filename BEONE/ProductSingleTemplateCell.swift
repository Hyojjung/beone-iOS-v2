
import UIKit

class ProductSingleTemplateCell: TemplateCell {
  
  @IBOutlet weak var productImageView: LazyLoadingImageView!
  @IBOutlet weak var labelsView: UIView!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var productSubTitleLabel: UILabel!
  @IBOutlet weak var discountPercentLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var originalPriceLabel: UILabel!
  @IBOutlet weak var priceLabelLeadingLayoutConstraint: NSLayoutConstraint!
  var productId: Int?
  var delegate: BaseViewController?

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
    delegate?.showProductView(productId)
  }
}
