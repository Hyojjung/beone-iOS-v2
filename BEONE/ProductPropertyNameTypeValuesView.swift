
import UIKit

let kRowValueButtonCount = 4

class ProductPropertyNameTypeValuesView: UIView {
  
  var buttons = [ProductPropertyValueView]()
  
  func layoutView(productProperty: ProductProperty, selectedProductPropertyValueIds: [Int]) {
    var beforeView: UIView?
    var leftBeforeView: UIView?
    for (index, productPropertyValue) in productProperty.values.enumerate() {
      let nibName = productProperty.displayType == .Color ?
        "ProductPropertyColorTypeValueView" : "ProductPropertyNameTypeValueView"
      let button = UIView.loadFromNibName(nibName) as! ProductPropertyValueView
      button.configureView(productPropertyValue, isSelected: selectedProductPropertyValueIds.contains(productPropertyValue.id!))
      addSubViewAndEnableAutoLayout(button)
      if index / kRowValueButtonCount == 0 {
        addTopLayout(button)
      } else {
        let verticalInterval = productProperty.displayType == .Color ?
          kValueColorViewVerticalInterval : kValueButtonVerticalInterval
        addVerticalLayout(leftBeforeView!, bottomView: button, contsant: verticalInterval)
      }
      
      if (productProperty.values.count - 1) / kRowValueButtonCount == index / kRowValueButtonCount {
        addBottomLayout(button)
      }

      if index % kRowValueButtonCount == 0 {
        addLeadingLayout(button)
      } else {
        addHorizontalLayout(beforeView!, rightView: button, contsant: 8)
      }
      
      if index % kRowValueButtonCount == kRowValueButtonCount - 1 {
        addTrailingLayout(button)
        leftBeforeView = button
      }
      beforeView = button
      buttons.append(button)
    }
    for (index, button) in buttons.enumerate() {
      if index < buttons.count - 1 {
        addEqualWidthLayout(button, view2: buttons[index + 1])
      }
    }
  }
}
