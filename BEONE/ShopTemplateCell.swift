
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
  
  override func configureCell(template: Template, forCalculateHeight: Bool) {
    super.configureCell(template, forCalculateHeight: forCalculateHeight)
    if let shop = template.content.models as? Shop {
      configureViews(shop)
    }
  }
  
  func configureCell(shop: Shop) {
    contentView.layoutMargins = UIEdgeInsetsZero
    templateContentsView.layoutMargins = UIEdgeInsetsZero
    configureViews(shop)
  }
  
  private func configureViews(shop: Shop) {
    shopImageView.setLazyLoaingImage(shop.backgroundImageUrl)
    nameLabel.text = shop.name
    descriptionLabel.text = shop.summary
    shopId = shop.id
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
