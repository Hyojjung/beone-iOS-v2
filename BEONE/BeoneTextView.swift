
import UIKit

class BeoneTextView: UITextView {
  
  var optionId: Int?
  
  var placeholder: String? {
    didSet {
      isModiFying = text != nil && !text.isEmpty
    }
  }
  
  var isHighlighted: Bool = true {
    didSet {
      if let superview = superview!.superview as? OptionTextView {
        superview.backgroundImageView.image =
          isHighlighted ? UIImage(named: kInputActiveImageName) : UIImage(named: kInputImageName)
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