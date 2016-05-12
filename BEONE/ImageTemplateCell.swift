
import UIKit

class ImageTemplateCell: TemplateCell {
  
  @IBOutlet weak var foregoundImageView: LazyLoadingImageView!
  
  // MARK: - Override Methods
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    foregoundImageView.setLazyLoaingImage(template.content.imageUrl)
    templateId = template.id
  }
  
  // MARK: - Actions
  
  @IBAction func viewTapped() {
    action?.action()
  }
}
