
import UIKit

class ProductDetailHeaderCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageScrollView: XLCCycleScrollView!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  
  var imageUrls: [String]?
  var product: Product?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imageScrollView.datasource = self
    imageScrollView.delegate = self
  }
  
  func configureCell(product: Product) {
    self.product = product
    if let isFavorite = self.product?.isFavorite() {
      self.favoriteButton.selected = isFavorite
    }
    productNameLabel.text = product.title
    imageUrls = product.productDetailImageUrls()
    imageScrollView.reloadData()
  }
}

// MARK: - XLCCycleScrollViewDatasource

extension ProductDetailHeaderCollectionViewCell: XLCCycleScrollViewDatasource {
  func numberOfPages() -> Int {
    if let imageUrls = imageUrls {
      return imageUrls.count
    }
    return 0
  }
  
  func pageAtIndex(index: Int) -> UIView! {
    if let imageUrls = imageUrls {
      let viewFrame = CGRectMake(0, 0, frame.width, frame.height)
      let imageUrl = imageUrls[index]
      let view = UIView(frame: viewFrame)
      let imageView = LazyLoadingImageView()
      imageView.frame = viewFrame
      imageView.contentMode = .ScaleAspectFill
      imageView.clipsToBounds = true
      imageView.setLazyLoaingImage(imageUrl)
      view.addSubview(imageView)
      return view
    }
    return nil
  }
}

extension ProductDetailHeaderCollectionViewCell: XLCCycleScrollViewDelegate {
  func didClickPage(csView: XLCCycleScrollView!, atIndex index: Int) {
    postNotification(kNotificationProductDetailImageTapped,
                     userInfo: [kNotificationKeyIndex: index, kNotificationKeyView: csView])
  }
}

// MARK: IB Actions

extension ProductDetailHeaderCollectionViewCell {
  
  @IBAction func favoriteButtonTapped(sender: UIButton) {
    if let product = self.product {
      if let productId = product.id {
        if !sender.selected {
          FavoriteProductHelper.postFavoriteProduct(productId, success: {
            sender.selected = !sender.selected
          })
        } else {
          FavoriteProductHelper.deleteFavoriteProduct(productId, success: {
            sender.selected = !sender.selected
          })
        }
      }
    }
    
  }
  
}