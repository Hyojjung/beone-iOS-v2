
import UIKit

class OptionView: UIView {
  
  weak var delegate: AnyObject?
  
  func layoutView(productOptionSetList: ProductOptionSetList) {
    subviews.forEach { $0.removeFromSuperview() }
    var previousView: UIView?
    for (index, productOptionSet) in productOptionSetList.list.enumerate() {
      if let productOptionSet = productOptionSet as? ProductOptionSet {
        previousView = addProductOptionSetSelectView(productOptionSet, previousView: previousView)
        
        for option in productOptionSet.options {
          if option.isSelected {
            for optionItem in option.optionItems {
              previousView = addOptionItemView(optionItem, previousView: previousView)
            }
          }
        }
      }
      if index != productOptionSetList.list.count - 1 {
        let lineView = UIView()
        lineView.backgroundColor = lightGold
        lineView.addHeightLayout(1)
        addSubViewAndEnableAutoLayout(lineView)
        addView(lineView, previousView: previousView)
        previousView = lineView
      } else if let previousView = previousView {
        addBottomLayout(previousView)
      }
    }
  }
  
  func addProductOptionSetSelectView(productOptionSet: ProductOptionSet, previousView: UIView?) -> UIView {
    if let productOptionSetSelectView = UIView.loadFromNibName("OptionSelectView") as? OptionTypeView {
      productOptionSetSelectView.delegate = delegate
      productOptionSetSelectView.layoutView(productOptionSet)
      
      addSubViewAndEnableAutoLayout(productOptionSetSelectView)
      addView(productOptionSetSelectView, previousView: previousView)
      return productOptionSetSelectView
    }
    fatalError("must load view with name OptionSelectView")
  }
  
  func addOptionItemView(optionItem: OptionItem, previousView: UIView?) -> UIView {
    let optionItemView: OptionTypeView
    switch optionItem.type {
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
    addView(optionItemView, previousView: previousView)
    return optionItemView
  }
  
  func addView(view: UIView, previousView: UIView?) {
    if let previousView = previousView {
      addVerticalLayout(previousView, bottomView: view, contsant: 10)
    } else {
      addTopLayout(view)
    }
    addLeadingLayout(view)
    addTrailingLayout(view)
  }
}
