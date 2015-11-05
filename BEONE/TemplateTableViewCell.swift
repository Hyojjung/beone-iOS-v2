
import UIKit

let kNibNameTemplateTableViewCell = "TemplateTableViewCell"
let kCellIdentifierTemplateTableViewCell = "templateTableViewCell"

class TemplateTableViewCell: UITableViewCell {
  @IBOutlet weak var templateView: TemplateView!
  
  func configureCell(template: Template) {
    templateView.layoutView(template)
  }
}
