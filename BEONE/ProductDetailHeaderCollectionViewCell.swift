
import UIKit

class ProductDetailHeaderCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageScrollView: XLCCycleScrollView!
  let imageUrls = ["/resources/images/products/josephflower/10.jpg", "/resources/images/products/wilddelicious/02.jpg", "/resources/images/products/candlysophie/07.jpg"]
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imageScrollView.datasource = self
    imageScrollView.delegate = self
  }
  
}

// MARK: - XLCCycleScrollViewDatasource

extension ProductDetailHeaderCollectionViewCell: XLCCycleScrollViewDatasource {
  func numberOfPages() -> Int {
    return imageUrls.count
  }
  
  func pageAtIndex(var index: Int) -> UIView! {
    while index >= imageUrls.count && imageUrls.count != 0 {
      index -= imageUrls.count
    }
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
}

extension ProductDetailHeaderCollectionViewCell: XLCCycleScrollViewDelegate {
  
}