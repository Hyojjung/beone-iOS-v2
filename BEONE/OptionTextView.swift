
import UIKit

class OptionTextView: OptionTypeView {
  
  weak var textViewDelegate: UITextViewDelegate?
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var placeholderLabel: UILabel!
  @IBOutlet weak var textView: BeoneTextView!
  
  override func layoutView(optionItem: BaseModel) {
    if let optionItem = optionItem as? OptionItem {
      textView.delegate = textViewDelegate
      textView.text = optionItem.value
      
      textView.placeholder = optionItem.placeholder
      textView.optionId = optionItem.id
    }
  }
}