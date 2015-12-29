
import UIKit

class OptionTextView: OptionTypeView {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var placeholderLabel: UILabel!
  @IBOutlet weak var textView: BeoneTextView!
  
  override func layoutView(optionItem: BaseModel) {
    if let optionItem = optionItem as? OptionItem {
      textView.placeholder = optionItem.placeholder
      textView.optionId = optionItem.id
      textView.delegate = delegate as? UITextViewDelegate
      
      placeholderLabel.text = optionItem.placeholder
      textView.text = optionItem.value
    }
  }
}

class BeoneTextView: UITextView {
  var placeholder: String?
  var optionId: Int?
  
  var isHighlighted: Bool = true {
    didSet {
      if let superview = superview!.superview as? OptionTextView {
        superview.backgroundImageView.image =
          isHighlighted ? UIImage(named: "inputActive") : UIImage(named: "Input")
      }
    }
  }
  
  var isModiFying: Bool = false {
    didSet {
      if let superview = superview!.superview as? OptionTextView {
        superview.placeholderLabel.text = isModiFying ? nil : placeholder
      }
    }
  }
}