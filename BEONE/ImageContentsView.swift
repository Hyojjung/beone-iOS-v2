
import UIKit

class ImageContentsView: TemplateContentsView {
  @IBOutlet weak var imageView: ImageContentsImageView!
  
  // MARK: - Override Methods
  
  override func className() -> String {
    return "Image"
  }
  
  override func layoutView(template: Template) {
    imageView.changeHeightLayoutConstant(template.height)
    imageView.setTemplateImage(template)
    templateId = template.id
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    if let templateId = templateId {
      postNotification(kNotificationDoAction, userInfo: [kNotificationKeyTemplateId: templateId])
    }
  }
}
