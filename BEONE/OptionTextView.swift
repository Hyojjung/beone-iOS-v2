
import UIKit

class OptionTextView: OptionTypeView {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var placeholderLabel: UILabel!
  @IBOutlet weak var textView: BeoneTextView!
  
  override func layoutView(optionItem: BaseModel) {
    if let optionItem = optionItem as? OptionItem {
      textView.text = optionItem.value
      
      textView.placeholder = optionItem.placeholder
      textView.optionId = optionItem.id
      textView.delegate = delegate as? UITextViewDelegate
    }
  }
}

class BeoneTextView: UITextView {
  var placeholder: String? {
    didSet {
      isModiFying = text != nil && !text.isEmpty
    }
  }
  var optionId: Int?
  
  var isHighlighted: Bool = true {
    didSet {
      if let superview = superview!.superview as? OptionTextView {
        superview.backgroundImageView.image =
          isHighlighted ? UIImage(named: "inputActive") : UIImage(named: "input")
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