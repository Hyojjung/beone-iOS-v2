
import UIKit

class ImageTemplateCell: TemplateCell {
  
  @IBOutlet weak var forgoundImageView: ImageContentsImageView!
  
  // MARK: - Override Methods
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    forgoundImageView.setTemplateImage(template)
    templateId = template.id
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    
  }
}
