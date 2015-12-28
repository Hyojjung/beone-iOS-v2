
import UIKit

class OptionStringView: OptionTypeView {
  
  @IBOutlet weak var textField: UITextField!
  
  override func layoutView(optionItem: BaseModel) {
    if let optionItem = optionItem as? OptionItem {
      textField.placeholder = optionItem.placeholder
      textField.text = optionItem.value
    }
  }
}
