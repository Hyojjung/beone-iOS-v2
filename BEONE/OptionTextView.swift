
import UIKit

class OptionTextView: OptionTypeView {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var placeholderLabel: UILabel!
  @IBOutlet weak var textView: BeoneTextView!
  
  override func layoutView(optionItem: BaseModel) {
    if let optionItem = optionItem as? OptionItem {
      textView.placeholder = optionItem.placeholder
      placeholderLabel.text = optionItem.placeholder
      textView.text = optionItem.value
      textView.delegate = delegate as? UITextViewDelegate
    }
  }
}

class BeoneTextView: UITextView {
  var placeholder: String?
  
  var isHighlighted: Bool = true {
    didSet {
      if let superview = superview!.superview as? OptionTextView {
        superview.backgroundImageView.image =
          isHighlighted ? UIImage(named: "bgInputTextareaActive") : UIImage(named: "bgInputTextarea")
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