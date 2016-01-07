
import UIKit
import SDWebImage

let kDefaultImageViewWidth = CGFloat(600)

class ImageContentsImageView: LazyLoadingImageView, TemplateContentsViewProtocol {
  var templateId: NSNumber?
  
  func setTemplateImage(template: Template) {
    templateId = template.id
    
    if let urlString = template.content.imageUrl {
      
      
      if let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(LazyLoadingHelper.imageUrlString(urlString, imageType: .Basic)) {
        self.image = image
        modifyHeightConstraint()
      } else if let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(LazyLoadingHelper.imageUrlString(urlString, imageType: ImageType.Original)) {
        self.image = image
        modifyHeightConstraint()
      } else {
        setLazyLoaingImage(template.content.imageUrl)
      }
    }
  }
  
  override func setImageWithAnimation(image: UIImage, cacheType: SDImageCacheType) {
    super.setImageWithAnimation(image, cacheType: cacheType)
    modifyHeightConstraint()
  }
  
  func modifyHeightConstraint() {
    if let height = image?.size.heightFromRatio(frame.size.width) {
      layoutContentsView(templateId, height: height, contentsView: self)
    }
  }
}

extension CGSize {
  func heightFromRatio(width: CGFloat) -> CGFloat {
    return height / self.width * width
  }
}