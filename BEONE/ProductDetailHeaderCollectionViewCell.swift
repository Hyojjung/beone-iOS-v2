
import UIKit

class ProductDetailHeaderCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageScrollView: XLCCycleScrollView!
  @IBOutlet weak var productNameLabel: UILabel!
  var imageUrls: [String]?
    
  override func awakeFromNib() {
    super.awakeFromNib()
    imageScrollView.datasource = self
    imageScrollView.delegate = self
  }
  
  func configureCell(product: Product) {
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