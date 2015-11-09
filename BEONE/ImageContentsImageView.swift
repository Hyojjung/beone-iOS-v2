
import UIKit
import SDWebImage

let kDefaultImageViewWidth = CGFloat(600)

class ImageContentsImageView: LazyLoadingImageView, TemplateContentsViewProtocol {
  var isLayouted = false
  var templateId: NSNumber?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if frame.width != kDefaultImageViewWidth {
      isLayouted = true
      modifyHeightConstraint()
    }
  }
  
  func setTemplateImage(template: Template) {
    templateId = template.id
    setLazyLoaingImage(template.contents.first?.imageUrl)
  }
  
  override func setImageWithAnimation(image: UIImage, cacheType: SDImageCacheType) {
    super.setImageWithAnimation(image, cacheType: cacheType)
    modifyHeightConstraint()
  }
  
  func modifyHeightConstraint() {
    if let image = image {
      let height = image.size.height / image.size.width * frame.size.width
      layoutContentsView(isLayouted, templateId: templateId, height: height, contentsView: self)
    }
  }
}
