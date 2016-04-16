
import UIKit
import SDWebImage

enum ImageType: Int {
  case Original
  case Thumbnail
  case Basic
}

class LazyLoadingImageView: UIImageView {
  
  deinit {
    image = nil
    sd_cancelCurrentImageLoad()
  }
  
  private func setLazyLoaingImage(urlString: String, imageType: ImageType) {
    let url = LazyLoadingHelper.imageUrl(urlString, imageType: imageType)
    sd_setImageWithURL(url, placeholderImage: image) { (image, error, cacheType, url) -> Void in
      if let image = image {
        if imageType == .Thumbnail {
          self.setLazyLoaingImage(urlString, imageType: .Basic)
        }
        self.setImageWithAnimation(image, cacheType: cacheType)
      } else {
        if imageType != .Original && !LazyLoadingHelper.originalImageUrls.contains(urlString) {
          LazyLoadingHelper.originalImageUrls.appendObject(urlString)
          self.setLazyLoaingImage(urlString, imageType: .Original)
        }
      }
    }
    // TODO: image load 방식 개선
  }
  
  func setImageWithAnimation(image: UIImage, cacheType: SDImageCacheType) {
    if cacheType == .Disk || cacheType == .Memory {
      self.image = image
    } else {
      UIView.transitionWithView(self,
        duration: 0.2,
        options: [.AllowUserInteraction, .TransitionCrossDissolve],
        animations: { 
          self.image = image
        },
        completion:nil)
    }
  }
  
  
  func setLazyLoaingImage(urlString: String?) {
    if let urlString = urlString {
      sd_cancelCurrentImageLoad()
      if LazyLoadingHelper.originalImageUrls.contains(urlString) {
        setLazyLoaingImage(urlString, imageType: .Original)
      } else {
        let thumbnailUrl = LazyLoadingHelper.imageUrl(urlString, imageType: .Thumbnail)
        let isThumbnailLoaded = SDWebImageManager.sharedManager().cachedImageExistsForURL(thumbnailUrl)
        setLazyLoaingImage(urlString, imageType: .Thumbnail)
        if isThumbnailLoaded {
          setLazyLoaingImage(urlString, imageType: .Basic)
        }
      }
    }
  }
}

class LazyLoadingHelper: NSObject {
  
  static var originalImageUrls = [String]()
  
  static func imageUrl(url: String, imageType: ImageType) -> NSURL {
    let urlString = imageType == .Original ? url : "\(url)?imageType=\(imageType.rawValue)"
    return urlString.url()
  }
  
  static func imageUrlString(url: String, imageType: ImageType) -> String {
    return imageUrl(url, imageType: imageType).absoluteString
  }
}

class ProductDetailImageView: LazyLoadingImageView {
  
  @IBOutlet weak var heightLayoutConstraint: NSLayoutConstraint!
  var productDetail: ProductDetail?
  
  override func setImageWithAnimation(image: UIImage, cacheType: SDImageCacheType) {
    super.setImageWithAnimation(image, cacheType: cacheType)
    if let image = self.image {
      let height = image.size.heightFromRatio(ViewControllerHelper.screenWidth)
      heightLayoutConstraint.constant = height
    }
  }
}