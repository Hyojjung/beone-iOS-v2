
import UIKit

protocol ShopTemplateCellDelegate: NSObjectProtocol {
  func shopButtonTapped(shopId: Int)
}

class ShopTemplateCell: TemplateCell {
  
  @IBOutlet weak var shopImageView: LazyLoadingImageView!
  @IBOutlet weak var shopProfileImageView: LazyLoadingImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var productCountLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var shopId: Int?

  override func awakeFromNib() {
    super.awakeFromNib()
    shopProfileImageView.makeCircleView()
  }
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    if let shops = template.content.models as? [Shop] {
      setUpView(shops.first)
    }
  }
  
  func configureView(shop: Shop?) {
    configureDefaulStyle()
    setUpView(shop)
  }
  
  private func setUpView(shop:Shop?) {
    if let shop = shop {
      shopImageView.image = UIImage(named: kimagePostThumbnail)
      shopProfileImageView.image = UIImage(named: kimagePostThumbnail)
      shopImageView.setLazyLoaingImage(shop.backgroundImageUrl)
      shopProfileImageView.setLazyLoaingImage(shop.profileImageUrl)
      nameLabel.text = shop.name
      descriptionLabel.text = shop.desc
      shopId = shop.id
      productCountLabel.text = "\(shop.productsCount)개의 플라워 판매 중"
    }
  }
}

// MARK: - Action

extension ShopTemplateCell {
  
  @IBAction func shopButtonTapped() {
    if let shopId = shopId {
      SchemeHelper.setUpScheme("current/shop/\(shopId)")
    }
  }
}
