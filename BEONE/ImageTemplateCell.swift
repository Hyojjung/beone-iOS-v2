
import UIKit

class ImageTemplateCell: TemplateCell {
  @IBOutlet weak var forgoundImageView: ImageContentsImageView!
  
  // MARK: - Override Methods
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    forgoundImageView.setTemplateImage(template)
    templateId = template.id
  }
  
  override func calculatedHeight(template: Template) -> CGFloat {
    var height: CGFloat = 0
    height += template.style.margin.top + template.style.margin.bottom
    height += template.style.padding.top + template.style.padding.bottom
    if let imageHeight = template.height {
      height += imageHeight
    }
    return height
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    if let templateId = templateId {
      postNotification(kNotificationDoAction, userInfo: [kNotificationKeyTemplateId: templateId])
    }
  }
}
