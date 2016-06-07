
import UIKit

class OptionStringView: OptionTypeView {

  @IBOutlet weak var textField: UITextField!
  var optionId: Int?
  
  override func layoutView(optionItem: BaseModel) {
    if let optionItem = optionItem as? OptionItem {
      textField.delegate = delegate as? UITextFieldDelegate
      textField.placeholder = optionItem.placeholder
      textField.text = optionItem.value
      optionId = optionItem.id
    }
  }
}
