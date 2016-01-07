
import UIKit

class ImageTemplateCell: TemplateCell {
  @IBOutlet weak var forgoundImageView: ImageContentsImageView!
  
  // MARK: - Override Methods
  
  override func configureCell(template: Template, forCalculateHeight: Bool) {
    super.configureCell(template, forCalculateHeight: forCalculateHeight)
    forgoundImageView.setTemplateImage(template)
    templateId = template.id
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    if let templateId = templateId {
      postNotification(kNotificationDoAction, userInfo: [kNotificationKeyTemplateId: templateId])
    }
  }
}
