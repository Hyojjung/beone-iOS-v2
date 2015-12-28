
import UIKit

class OptionView: UIView {

  weak var delegate: AnyObject?

  func layoutView(productOptionSetList: ProductOptionSetList) {
    subviews.forEach { $0.removeFromSuperview() }
    var beforeView: UIView?
    for (index, productOptionSet) in productOptionSetList.list.enumerate() {
      if let productOptionSet = productOptionSet as? ProductOptionSet {
        beforeView = addProductOptionSetSelectView(productOptionSet, beforeView: beforeView)
        
        for option in productOptionSet.options {
          if option.isSelected {
            for optionItem in option.optionItems {
              beforeView = addOptionItemView(optionItem, beforeView: beforeView)
            }
          }
        }
      }
      if index != productOptionSetList.list.count - 1 {
        let lineView = UIView()
        lineView.backgroundColor = lightGold
        lineView.addHeightLayout(1)
        addSubViewAndEnableAutoLayout(lineView)
        addView(lineView, beforeView: beforeView)
        beforeView = lineView
      } else if let beforeView = beforeView {
        addBottomLayout(beforeView)
      }
    }
  }
  
  func addProductOptionSetSelectView(productOptionSet: ProductOptionSet, beforeView: UIView?) -> UIView {
    if let productOptionSetSelectView = UIView.loadFromNibName("OptionSelectView") as? OptionTypeView {
      productOptionSetSelectView.delegate = delegate
      productOptionSetSelectView.layoutView(productOptionSet)

      addSubViewAndEnableAutoLayout(productOptionSetSelectView)
      addView(productOptionSetSelectView, beforeView: beforeView)
      return productOptionSetSelectView
    }
    fatalError("must load view with name OptionSelectView")
  }
  
  func addOptionItemView(optionItem: OptionItem, beforeView: UIView?) -> UIView {
    if let type = optionItem.type {
      let optionItemView: OptionTypeView
      switch type {
      case .Text:
        optionItemView = UIView.loadFromNibName("OptionTextView") as! OptionTypeView
      case .String:
        optionItemView = UIView.loadFromNibName("OptionStringView") as! OptionTypeView
      case .Select:
        optionItemView = UIView.loadFromNibName("OptionSelectView") as! OptionTypeView
      }
      optionItemView.delegate = delegate
      optionItemView.layoutView(optionItem)
      
      addSubViewAndEnableAutoLayout(optionItemView)
      addView(optionItemView, beforeView: beforeView)
      return optionItemView
    }
    fatalError("optionItem must have type")
  }
  
  func addView(view: UIView, beforeView: UIView?) {
    if let beforeView = beforeView {
      addConstraint(NSLayoutConstraint(item: beforeView,
        attribute: .Bottom,
        relatedBy: .Equal,
        toItem: view,
        attribute: .Top,
        multiplier: 1,
        constant: -10))
    } else {
      addTopLayout(view)
    }
    addLeftLayout(view)
    addRightLayout(view)
  }
}
