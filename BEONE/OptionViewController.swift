
import UIKit

class OptionViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum OptionTableViewSection: Int {
    case Product
    case DeliveryInfo
    case Option
    case CartItemCount
    case Button
    case Count
  }
  
  private let kOptionTableViewCellIdentifiers =
  ["productCell", "deliveryInfoCell", "optionCell", "cartItemCountCell", "buttonCell"]
  private let kQuantityStrings = ["1", "2", "3", "4", "5"]
  
  // MARK: - Property
  
  var product = Product()
  var cartItems = CartItems()
  var selectedOption: ProductOptionSets?
  var isModifing = false
  var isOrdering = false
  
  private var selectedProductOrderableInfo: ProductOrderableInfo?
  private var deliveryTypeNames = [String]()
  
  deinit {
    if isOrdering {
      cartItems.delete()
    }
  }
  
  // MARK: - BaseViewController Methods
  
  override func setUpData() {
    super.setUpData()
    product.get({ () -> Void in
      if self.product.soldOut {
        let confirmAction = Action()
        confirmAction.type = .Method
        confirmAction.content = "popView"
        
        self.showAlertView(NSLocalizedString("sold out product", comment: "alert title"), confirmAction: confirmAction, delegate: self)
      } else {
        self.setUpProductData()
      }
    })
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  // MARK: - Observer Actions
  
  func setUpProductData() {
    setUpProductDeliveryTypeNames()
    
    if isModifing && cartItems.count == 1 {
      if let cartItem = cartItems.list.first as? CartItem {
        selectedProductOrderableInfo = cartItem.productOrderableInfo
        if let selectedOption = cartItem.selectedOption {
          self.selectedOption = selectedOption.copy() as? ProductOptionSets
        }
      }
    } else if !isModifing {
      if product.productOrderableInfos.count == 1 {
        selectedProductOrderableInfo = product.productOrderableInfos.first
      }
      if product.productOptionSets.list.count == 0 && cartItems.count == 0 {
        addCartItemButtonTapped()
        return
      }
      selectedOption = product.productOptionSets.copy() as? ProductOptionSets
    }
    
    tableView.reloadData()
  }
  
  private func setUpProductDeliveryTypeNames() {
    deliveryTypeNames.removeAll()
    for productOrderableInfo in product.productOrderableInfos {
      if let name = productOrderableInfo.deliveryType.name {
        deliveryTypeNames.appendObject(name)
      }
    }
  }
  
  func handlePostCartItemSuccess() {
    if isOrdering {
      showOrderView(cartItems.ids())
    } else if isModifing {
      popView()
    } else {
      let confirmAction = Action()
      confirmAction.type = .Scheme
      confirmAction.content = "home/cart"
      
      let cancelAction = Action()
      cancelAction.type = .Method
      cancelAction.content = "popView"
      
      showAlertView("장바구니에 담긴 상품을 확인하시겠습니까?",
        hasCancel: true, confirmAction: confirmAction, cancelAction: cancelAction,
        delegate: self)
    }
  }
}

// MARK: - Actions

extension OptionViewController {
  
  @IBAction func sendCart() {
    if let productOrderableInfo = selectedProductOrderableInfo {
      if cartItems.count > 0 {
        for cartItem in cartItems.list as! [CartItem] {
          cartItem.productOrderableInfo = productOrderableInfo
        }
        if !isModifing {
          cartItems.post({ (_) in
            self.handlePostCartItemSuccess()
          })
        } else if cartItems.count == 1 {
          if let cartItem = cartItems.list.first as? CartItem {
            cartItem.selectedOption = selectedOption
            cartItem.put({ (result) -> Void in
              self.handlePostCartItemSuccess()
            })
          }
        }
      } else {
        showAlertView(NSLocalizedString("select option", comment: "alert title"))
      }
    } else {
      showAlertView(NSLocalizedString("select delivery type", comment: "alert title"))
    }
  }
  
  @IBAction func selectDeliveryTypeButtonTapped(sender: UIButton) {
    var initialSelection = 0
    for (index, productOrderableInfo) in product.productOrderableInfos.enumerate() {
      if productOrderableInfo.id == selectedProductOrderableInfo?.id {
        initialSelection = index
      }
    }
    if deliveryTypeNames.count > 0 {
      showActionSheet(NSLocalizedString("select delivery type", comment: "picker title"),
        rows: deliveryTypeNames,
        initialSelection: initialSelection,
        sender: sender,
        doneBlock: { (_, selectedIndex, _) -> Void in
          self.selectedProductOrderableInfo = self.product.productOrderableInfos[selectedIndex]
          self.tableView.reloadData()
      })
    }
  }
  
  @IBAction func selectQuantityButtonTapped(sender: UIButton) {
    if cartItems.count > sender.tag {
      let cartItem = cartItems.list[sender.tag] as! CartItem
      showActionSheet(NSLocalizedString("select quantity", comment: "picker title"),
        rows: kQuantityStrings,
        initialSelection: cartItem.quantity - 1,
        sender: sender,
        doneBlock: { (_, selectedIndex, _) -> Void in
          cartItem.quantity = selectedIndex + 1
          self.tableView.reloadData()
      })
    }
  }
  
  @IBAction func deleteCartItemButtonTapped(sender: UIButton) {
    if cartItems.count > sender.tag {
      cartItems.list.removeAtIndex(sender.tag)
      tableView.reloadData()
    }
  }
  
  @IBAction func addCartItemButtonTapped() {
    if let validationMessage = selectedOption?.validationMessage() {
      showAlertView(validationMessage)
    } else {
      let cartItem = CartItem()
      cartItem.product = product
      cartItem.selectedOption = selectedOption?.copy() as? ProductOptionSets
      selectedOption = product.productOptionSets.copy() as? ProductOptionSets
      cartItems.list.appendObject(cartItem)
      tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource

extension OptionViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return OptionTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch OptionTableViewSection(rawValue: section)! {
    case .Option:
      return product.productOptionSets.list.count == 0 ? 0 : 1
    case .CartItemCount:
      return isModifing ? 0 : cartItems.list.count
    default:
      return 1
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}


// MARK: - DynamicHeightTableViewDelegate

extension OptionViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kOptionTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? DeliveryInfoCell {
      return cell.calculatedHeight(selectedProductOrderableInfo)
    } else if let cell = cell as? CartItemCountCell {
      return cell.calculatedHeight(cartItems.list[indexPath.row] as! CartItem)
    } else if let cell = cell as? OptionCell {
      return cell.calculatedHeight(selectedOption, needButton: !isModifing)
    }
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? ProductCell {
      cell.configureCell(product)
    } else if let cell = cell as? DeliveryInfoCell {
      cell.configureCell(selectedProductOrderableInfo)
    } else if let cell = cell as? ButtonCell {
      cell.configureCell(isOrdering)
    } else if let cell = cell as? CartItemCountCell {
      cell.configureCell(cartItems.list[indexPath.row] as! CartItem, indexPath: indexPath)
    } else if let cell = cell as? OptionCell {
      cell.delegate = self
      cell.configureCell(selectedOption, needButton: !isModifing)
    }
  }
}

extension OptionViewController: OptionDelegate {
  func optionSelectButtonTapped(optionId: Int, isProductOptionSet: Bool, sender: UIButton) {
    endEditing()
    var optionValues = [String]()
    var initialSelection = 0
    if isProductOptionSet {
      for (index, option) in selectedOption(optionId).options.enumerate() {
        if let name = option.optionName() {
          optionValues.appendObject(name)
        }
        if option.isSelected {
          initialSelection = index
        }
      }
      showActionSheet( NSLocalizedString("select option", comment: "picker title"),
        rows: optionValues,
        initialSelection: initialSelection,
        sender: sender,
        doneBlock: { (_, selectedIndex, _) -> Void in
          for (index, option) in self.selectedOption(optionId).options.enumerate() {
            option.isSelected = index == selectedIndex
          }
          self.tableView.reloadData()
      })
    } else {
      for (index, select) in selectedOptionItem(optionId).selects.enumerate() {
        if let name = select.selectName() {
          optionValues.appendObject(name)
        }
        if select.name == selectedOptionItem(optionId).name {
          initialSelection = index
        }
      }
      showActionSheet( NSLocalizedString("select option", comment: "picker title"),
        rows: optionValues,
        initialSelection: initialSelection,
        sender: sender,
        doneBlock: { (_, selectedIndex, _) -> Void in
          for (index, select) in self.selectedOptionItem(optionId).selects.enumerate() {
            if index == selectedIndex {
              self.selectedOptionItem(optionId).value = select.name
              self.selectedOptionItem(optionId).selectedName = select.selectName()
            }
          }
          self.tableView.reloadData()
      })
    }
    
  }
  
  func selectedOption(optionId: Int) -> ProductOptionSet {
    for productOptionSet in selectedOption!.list as! [ProductOptionSet] {
      if productOptionSet.id == optionId {
        return productOptionSet
      }
    }
    fatalError("no product option set")
  }
  
  func selectedOptionItem(optionId: Int) -> OptionItem {
    for productOptionSet in selectedOption!.list as! [ProductOptionSet] {
      for option in productOptionSet.options {
        for optionItem in option.optionItems {
          if optionItem.id == optionId {
            return optionItem
          }
        }
      }
    }
    fatalError("no option item")
  }
}

extension OptionViewController: UITextViewDelegate {
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    if let textView = textView as? BeoneTextView {
      tableView.focusOffset = textView.convertPoint(textView.frame.origin, toView: tableView).y - 250
      textView.isHighlighted = true
    }
    return true
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    if let textView = textView as? BeoneTextView {
      textView.isHighlighted = false
    }
  }
  
  func textViewDidChange(textView: UITextView) {
    if let textView = textView as? BeoneTextView, optionId = textView.optionId {
      let optionItem = selectedOptionItem(optionId)
      optionItem.value = textView.text
      textView.isModiFying = !(textView.text == kEmptyString || textView.text == nil)
    }
  }
}