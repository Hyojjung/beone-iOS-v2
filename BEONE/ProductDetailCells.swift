
import UIKit

class ProductDetailCell: UICollectionViewCell {
  
  @IBOutlet weak var containerView: UIView!
  
  func configureCell(product: Product, indexPath: NSIndexPath) {
    containerView.changeWidthLayoutConstant(ViewControllerHelper.screenWidth)
  }
}

class RateCell: ProductDetailCell {
  
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet var rateImageViews: [UIImageView]!
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    for imageView in rateImageViews {
      imageView.highlighted = product.rate >= imageView.tag
    }
    summaryLabel.text = product.summary
  }
}

class PriceCell: ProductDetailCell {
  
  @IBOutlet weak var actualPriceLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    actualPriceLabel.text = product.actualPrice.priceNotation(.Korean)
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
    deliveryLabel.text = product.deliveryInfo
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
    quantityAndSize = "\(product.quantity)개 "
    if let size = product.size {
      quantityAndSize += size
    }
    return quantityAndSize
  }
}

class ProductDesctriptionCell: ProductDetailCell {
  
  @IBOutlet weak var imageView: ProductDetailImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var imageButton: UIButton?
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    imageButton?.tag = indexPath.row
  }
  
  func setUpView(productDetail: ProductDetail, buttonEnabled: Bool) {
    imageView.image = nil
    imageView.sd_cancelCurrentImageLoad()
    imageView.heightLayoutConstraint.priority = UILayoutPriorityDefaultLow
    titleLabel.text = nil
    descriptionLabel.text = nil
    
    imageButton?.enabled = buttonEnabled && productDetail.detailType == .Image
    
    if let detailType = productDetail.detailType {
      switch detailType {
      case .Image:
        imageView.heightLayoutConstraint.priority = UILayoutPriorityDefaultHigh
        imageView.productDetail = productDetail
        imageView.setLazyLoaingImage(productDetail.content)
      case .Title:
        titleLabel.text = productDetail.content
      case .Text:
        descriptionLabel.text = productDetail.content
      }
    }
  }
}

class ProductMainDesctriptionCell: ProductDesctriptionCell {
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    let productDetail = product.productDetails[indexPath.row]
    setUpView(productDetail, buttonEnabled: true)
  }
}

class ProductHeaderDesctriptionCell: ProductDesctriptionCell {
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    let productDetail = product.productDetailHeaders[indexPath.row]
    setUpView(productDetail, buttonEnabled: true)
  }
}


class ProductFooterDesctriptionCell: ProductDesctriptionCell {
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    let productDetail = product.productDetailFooters[indexPath.row]
    setUpView(productDetail, buttonEnabled: true)
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
    shopSummaryLabel.text = product.shop.desc
  }
}

class ReviewSummaryCell: ProductDetailCell {
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  @IBOutlet var rateImageViews: [UIImageView]!
  @IBOutlet var imageViews: [LazyLoadingImageView]?
  @IBOutlet var imageButtons: [UIButton]?
  @IBOutlet weak var moreImageView: LazyLoadingImageView?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    if let imageViews = imageViews {
      for imageView in imageViews {
        imageView.makeCircleView()
      }
    }
  }
  
  override func configureCell(product: Product, indexPath: NSIndexPath) {
    super.configureCell(product, indexPath: indexPath)
    let review = product.reviews[indexPath.row]
    
    userNameLabel.text = review.userName
    createdAtLabel.text = review.createdAt?.briefDateString()
    createdAtLabel.preferredMaxLayoutWidth = ViewControllerHelper.screenWidth - 32
    contentLabel.text = review.content
    
    if let imageButtons = imageButtons {
      for imageButton in imageButtons {
        imageButton.configureAlpha(review.reviewImageUrls.isInRange(imageButton.tag))
        imageButton.superview?.tag = review.id!
      }
    }
    if let imageViews = imageViews {
      for imageView in imageViews {
        imageView.image = nil
        imageView.setLazyLoaingImage(review.reviewImageUrls.objectAtIndex(imageView.tag))
      }
    }
    for imageView in rateImageViews {
      imageView.highlighted = review.rate >= imageView.tag
    }
    
    moreImageView?.highlighted = review.reviewImageUrls.count > 3
  }
}
