
import UIKit

protocol ShopTemplateCellDelegate: NSObjectProtocol {
  func shopButtonTapped(shopId: Int)
}

class ShopTemplateCell: TemplateCell {
  
  weak var delegate: ShopTemplateCellDelegate?
  var shopId: Int?
  
  @IBOutlet weak var shopImageView: LazyLoadingImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var productCountLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    if let shops = template.content.models as? [Shop] {
      configureView(shops.first)
    }
  }
  
  func configureView(shop: Shop?) {
    configureDefaulStyle()
    if let shop = shop {
      shopImageView.setLazyLoaingImage(shop.backgroundImageUrl)
      nameLabel.text = shop.name
      descriptionLabel.text = shop.desc
      shopId = shop.id
    }
    // TODO: Product Count
  }
}

// MARK: - Action

extension ShopTemplateCell {
  
  @IBAction func shopButtonTapped() {
    if let shopId = shopId {
      delegate?.shopButtonTapped(shopId)
    }
  }
}
