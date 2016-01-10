
import UIKit
import SDWebImage

class ImageContentsImageView: LazyLoadingImageView {
  
  var template: Template?
  
  override func setImageWithAnimation(image: UIImage, cacheType: SDImageCacheType) {
    super.setImageWithAnimation(image, cacheType: cacheType)
    modifyHeightConstraint()
  }
  
  func setTemplateImage(template: Template) {
    self.template = template
    
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
  
  func modifyHeightConstraint() {
    if let height = heightFromRatio(image?.size) {
      if self.template?.height != height {
        self.template?.height = height
        postNotification(kNotificationContentsViewLayouted)
      }
    }
  }
  
  private func heightFromRatio(imageSize: CGSize?) -> CGFloat? {
    if let template = template {
      let width = ViewControllerHelper.screenWidth -
        (template.style.margin.left + template.style.margin.right +
          template.style.padding.left + template.style.padding.right)
      return imageSize?.heightFromRatio(width)
    }
    return nil
  }
}

extension CGSize {
  func heightFromRatio(width: CGFloat) -> CGFloat {
    return height / self.width * width
  }
}