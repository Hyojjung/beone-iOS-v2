
import UIKit

class OptionView: UIView {
  
  func layoutView(productOptionSetList: ProductOptionSetList) {
    subviews.forEach { $0.removeFromSuperview() }
    var beforeView: UIView?
    for (index, productOptionSet) in productOptionSetList.list.enumerate() {
      if let productOptionSet = productOptionSet as? ProductOptionSet {
        if let productOptionSetSelectView = UIView.loadFromNibName("OptionSelectView") {
          addSubViewAndEnableAutoLayout(productOptionSetSelectView)
          addView(productOptionSetSelectView, beforeView: beforeView)
          beforeView = productOptionSetSelectView
        }
        
        for option in productOptionSet.options {
          if option.isSelected {
            for optionItem in option.optionItems {
              if let type = optionItem.type {
                let optionItemView: UIView
                switch type {
                case .Text:
                  optionItemView = UIView.loadFromNibName("optionTextView")!
                case .String:
                  optionItemView = UIView.loadFromNibName("optionStringView")!
                case .Select:
                  optionItemView = UIView.loadFromNibName("optionSelectView")!
                }
                addSubViewAndEnableAutoLayout(optionItemView)
                addView(optionItemView, beforeView: beforeView)
                beforeView = optionItemView
              }
            }
          }
        }
      }
      if index != productOptionSetList.list.count - 1 {
        let lineView = UIView()
        lineView.addHeightLayout(1)
        addSubViewAndEnableAutoLayout(lineView)
        addView(lineView, beforeView: beforeView)
        beforeView = lineView
      } else if let beforeView = beforeView {
        addBottomLayout(beforeView)
      }
    }
  }
  
  
  func addView(view: UIView, beforeView: UIView?) {
    if let beforeView = beforeView {
      addConstraint(NSLayoutConstraint(item: beforeView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    } else {
      addTopLayout(view)
    }
    addLeftLayout(view)
    addRightLayout(view)
  }
}
