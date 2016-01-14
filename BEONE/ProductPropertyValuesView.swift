
import UIKit


let kRowValueButtonCount = 4
let kViewHorizontalInterval = CGFloat(8)

class ProductPropertyValuesView: UIView {
  
  var views = [ProductPropertyValueView]()
  
  func layoutView(productPropertyValueList: [BaseModel], selectedProductPropertyValueIds: [Int],
    displayType: ProductPropertyDisplayType? = nil) {
    var beforeView: UIView?
    var beforeRowLeftView: UIView?
    
    for (index, productPropertyValue) in productPropertyValueList.enumerate() {
      let view = propertyValueView(productPropertyValue, displayType: displayType)
      view.configureView(productPropertyValue, isSelected: selectedProductPropertyValueIds.contains(productPropertyValue.id!))
      
      beforeRowLeftView = self.beforeRowLeftView(view,
        count: productPropertyValueList.count,
        index: index,
        beforeRowLeftView: beforeRowLeftView,
        beforeView: beforeView)
      beforeView = view
      
      views.append(view)
    }
    configureSubViewsWidthLayout(views)
  }
  
  private func propertyValueView(productPropertyValue: BaseModel,
    displayType: ProductPropertyDisplayType?) -> ProductPropertyValueView {
    let nibName: String
    if displayType == .Color {
      nibName = kProductPropertyColorTypeValueViewNibName
    } else {
      nibName = kProductPropertyNameTypeValueViewNibName
    }
    return UIView.loadFromNibName(nibName) as! ProductPropertyValueView
  }
  
  private func configureSubViewsWidthLayout(views: [UIView]) {
    if views.count < kRowValueButtonCount {
      for view in views {
        let constant: CGFloat = kViewHorizontalInterval * (CGFloat(kRowValueButtonCount) - 1)
        addWidthLayout(constant, multiplier: CGFloat(kRowValueButtonCount), view: view)
      }
    } else {
      for (index, view) in views.enumerate() {
        if index < views.count - 1 {
          addEqualWidthLayout(view, view2: views[index + 1])
        }
      }
    }
  }
}

// MARK: - Layout Methods

extension ProductPropertyValuesView {
  private func beforeRowLeftView(view: UIView, count: Int, index: Int, beforeRowLeftView: UIView?, beforeView: UIView?) -> UIView? {
    addSubViewAndEnableAutoLayout(view)
    
    configureTopLayout(view, index: index, beforeRowLeftView: beforeRowLeftView)
    configureBottomLayout(view, count: count, index: index)
    configureLeftLayout(view, index: index, beforeView: beforeView)
    
    if index % kRowValueButtonCount == kRowValueButtonCount - 1 {
      addTrailingLayout(view)
      return view
    }
    return beforeRowLeftView
  }
  
  private func configureTopLayout(view: UIView, index: Int, beforeRowLeftView: UIView?) {
    if index / kRowValueButtonCount == 0 {
      addTopLayout(view)
    } else if let beforeRowLeftView = beforeRowLeftView {
      let verticalInterval = kValueButtonVerticalInterval
      addVerticalLayout(beforeRowLeftView, bottomView: view, contsant: verticalInterval)
    }
  }
  
  private func configureBottomLayout(view: UIView, count: Int, index: Int) {
    if (count - 1) / kRowValueButtonCount == index / kRowValueButtonCount {
      addBottomLayout(view)
    }
  }
  
  private func configureLeftLayout(view: UIView, index: Int, beforeView: UIView?) {
    if index % kRowValueButtonCount == 0 {
      addLeadingLayout(view)
    } else if let beforeView = beforeView {
      addHorizontalLayout(beforeView, rightView: view, contsant: kViewHorizontalInterval)
    }
  }
}
