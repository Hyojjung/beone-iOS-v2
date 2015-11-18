
import UIKit

let kTemplateTableViewCellNibName = "TemplateTableViewCell"
let kTemplateTableViewCellIdentifier = "templateTableViewCell"

class TemplateTableViewCell: UITableViewCell {
  @IBOutlet weak var templateView: TemplateView!
  
  func configureCell(template: Template) {
    templateView.layoutView(template)
  }
}
