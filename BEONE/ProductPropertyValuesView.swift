
import UIKit


let kRowValueButtonCount = 4
let kViewHorizontalInterval = CGFloat(8)

class ProductPropertyValuesView: UIView {
  
  var views = [SearchValueView]()
  
  func layoutView(productPropertyValueList: [BaseModel], selectedSearchValueIds: [Int], delegate: AnyObject,
    displayType: ProductPropertyDisplayType? = nil) {
      var beforeView: UIView?
      var beforeRowLeftView: UIView?
      
      for (index, productPropertyValue) in productPropertyValueList.enumerate() {
        let view = searchValueView(productPropertyValue, displayType: displayType)
        view.needBackgoundColor = displayType != .Color
        view.delegate = delegate as? SearchValueDelegate
        view.configureView(productPropertyValue, isSelected: selectedSearchValueIds.contains(productPropertyValue.id!))
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
  
  private func searchValueView(productPropertyValue: BaseModel, displayType: ProductPropertyDisplayType?) -> SearchValueView {
    return UIView.loadFromNibName(ProductPropertyViewHelper.viewNibName(displayType)) as! SearchValueView
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
    } else if let beforeRowLeftView = beforeRowLeftView as? SearchValueView {
      let verticalInterval = ProductPropertyViewHelper.buttonInterval(beforeRowLeftView.viewDisplayType)
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

class ProductPropertyViewHelper {
  static func buttonViewHeight(displayType: ProductPropertyDisplayType?) -> CGFloat {
    if displayType == .Color {
      return 41 + (ViewControllerHelper.screenWidth - 48) / 4
    } else {
      return 23
    }
  }
  
  static func buttonInterval(displayType: ProductPropertyDisplayType?) -> CGFloat {
    if displayType == .Color {
      return 5
    } else {
      return 18
    }
  }
  
  static func viewNibName(displayType: ProductPropertyDisplayType?) -> String {
    if displayType == .Color {
      return kProductPropertyColorTypeValueViewNibName
    } else {
      return kProductPropertyNameTypeValueViewNibName
    }
  }
}
