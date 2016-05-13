
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

class BeoneTextField: UITextField {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    leftView = UIView(frame: CGRectMake(0, 0, 8, 20))
    leftViewMode = .Always
  }
}

class BeoneTextView1: UITextView {
  var isHighlighted: Bool = false {
    didSet {
      if let superview = superview {
        for view in superview.subviews {
          if let imageView = view as? UIImageView {
            imageView.image = isHighlighted ? UIImage(named: kInputActiveImageName) : UIImage(named: kInputImageName)
          }
        }
      }
    }
  }
}