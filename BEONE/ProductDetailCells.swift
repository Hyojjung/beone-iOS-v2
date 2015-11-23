
import UIKit

class ProductDetailCell: UICollectionViewCell {
  @IBOutlet weak var containerView: UIView!
  
  func configureCell(product: Product, indexPath: NSIndexPath) {
    containerView.changeWidthLayoutConstant(ViewControllerHelper.screenWidth)
  }
}

class RateCell: ProductDetailCell {
  @IBOutlet weak var summaryLabel: UILabel!
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    // TODO: - Rate
    summaryLabel.text = product.summary
  }
}

class PriceCell: ProductDetailCell {
  @IBOutlet weak var actualPriceLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    actualPriceLabel.text = product.actualPrice?.priceNotation(.Korean)
    priceLabel.attributedText = product.priceAttributedString()
  }
}

class InfoCell: ProductDetailCell {
  @IBOutlet weak var productCodeLabel: UILabel!
  @IBOutlet weak var deliveryLabel: UILabel!
  @IBOutlet weak var sellerLabel: UILabel!
  @IBOutlet weak var countryLabel: UILabel!
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    productCodeLabel.text = product.productCode
    // TODO: - delivery info
    sellerLabel.text = product.shop.name
    countryLabel.text = product.countryInfo
  }
}

class DetailInfoCell: ProductDetailCell {
  @IBOutlet weak var sizeLabel: UILabel!
  @IBOutlet weak var shelfLifeLabel: UILabel!
  @IBOutlet weak var compositionLabel: UILabel!
  @IBOutlet weak var relatedLawLabel: UILabel!
  @IBOutlet weak var keepingLabel: UILabel!
  @IBOutlet weak var phoneNumberLabel: UILabel!
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    sizeLabel.text = productQantityAndSizeString(product)
    compositionLabel.text = product.composition
    relatedLawLabel.text = product.relatedLawInfo
    shelfLifeLabel.text = product.shelfLife
    keepingLabel.text = product.keepingMethod
    phoneNumberLabel.text = product.contact
  }
  
  private func productQantityAndSizeString(product: Product) -> String {
    var quantityAndSize = String()
    if let quantity = product.quantity {
      quantityAndSize = "\(quantity)개 "
    }
    if let size = product.size {
      quantityAndSize = quantityAndSize.stringByAppendingString(size)
    }
    return quantityAndSize
  }
}

class ProductDesctriptionCell: ProductDetailCell {
  @IBOutlet weak var imageView: ProductDetailImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    let productDetail = product.productDetails[indexPath.row]
    imageView.image = nil
    titleLabel.text = nil
    descriptionLabel.text = nil
    
    switch productDetail.detailType! {
    case .Image:
      imageView.setLazyLoaingImage(productDetail.content)

    case .Title:
      titleLabel.text = productDetail.content
    case .Text:
      descriptionLabel.text = productDetail.content
    }
  }
}

class PrecautionCell: ProductDetailCell {
  @IBOutlet weak var precautionLabel: UILabel!
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    precautionLabel.text = product.precaution
  }
}

class ProductShopCell: ProductDetailCell {
  @IBOutlet weak var shopImageView: LazyLoadingImageView!
  @IBOutlet weak var shopNameLabel: UILabel!
  @IBOutlet weak var shopSummaryLabel: UILabel!
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    shopImageView.setLazyLoaingImage(product.shop.backgroundImageUrl)
    shopNameLabel.text = product.shop.name
    shopSummaryLabel.text = product.shop.summary
  }
}
