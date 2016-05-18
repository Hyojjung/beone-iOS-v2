
import UIKit

class OptionViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum OptionTableViewSection: Int {
    case Product
    case DeliveryInfo
    case Option
    case AddCartItem
    case CartItemCount
    case Button
    case Count
  }
  
  private let kOptionTableViewCellIdentifiers =
    ["productCell", "deliveryInfoCell", "optionCell", "addCartItemCell", "cartItemCountCell", "buttonCell"]
  private let kQuantityStrings = ["1", "2", "3", "4", "5"]
  
  // MARK: - Property
  
  var product = Product()
  var cartItems = [CartItem]()
  var selectedOption: ProductOptionSets?
  var orderingCartItemIds = [Int]()
  var isModifing = false
  var isOrdering = true
  
  private var selectedProductOrderableInfo: ProductOrderableInfo?
  private var deliveryTypeNames = [String]()
  
  deinit {
    if isOrdering {
      CartItemManager.removeCartItem(orderingCartItemIds)
    }
  }
  
  // MARK: - BaseViewController Methods
  
  override func setUpData() {
    super.setUpData()
    if product.id != nil {
      product.get({
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
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  // MARK: - Observer Actions
  
  func setUpProductData() {
    setUpProductDeliveryTypeNames()
    setUpToDefault()
    if product.productOptionSets.list.count == 0 && cartItems.count == 0
      && selectedProductOrderableInfo != nil {
      addCartItemButtonTapped()
      return
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
      var cartItemIds = [Int]()
      for cartItem in cartItems {
        orderingCartItemIds.appendObject(cartItem.id)
        cartItemIds.appendObject(cartItem.id)
      }
      showOrderView(cartItemIds)
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
    if cartItems.count < 1 {
      addCartItem(true)
    } else {
      sendCartItems()
    }
  }
  
  func sendCartItems() {
    // 수정 시 첫 번째 카트 아이템을 지우고 다른 카트아이템 추가시 첫 번째 카트 아이템이 안지워지는 버그 존재
    if isModifing && cartItems.first!.id != nil {
      // 첫 번째 카트 아이템의 아이디가 있는 경우,
      // 첫 번재 카트 아이템은 수정, 나머지 카트 아이템은 추가.
      cartItems.first!.put({ (result) -> Void in
        self.cartItems.removeAtIndex(0);
        self.postCartItems(self.cartItems)
      })
      
    } else {
      postCartItems(self.cartItems)
    }
  }
  
  func postCartItems(cartItems: [CartItem]) {
    CartItemManager.postCartItems(cartItems, postSuccess: { (cartItems) in
      self.cartItems = cartItems
      self.handlePostCartItemSuccess()
    })
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
      let cartItem = cartItems[sender.tag]
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
      cartItems.removeAtIndex(sender.tag)
      tableView.reloadData()
    }
  }
  
  @IBAction func addCartItemButtonTapped() {
    addCartItem()
  }
  
  func addCartItem(needPost: Bool = false) {
    if let validationMessage = selectedOption?.validationMessage() {
      showAlertView(validationMessage)
    } else if let selectedProductOrderableInfo = selectedProductOrderableInfo {
      let cartItem = CartItem()
      cartItem.product = product
      cartItem.productOrderableInfo = selectedProductOrderableInfo
      cartItem.selectedOption = selectedOption?.copy() as? ProductOptionSets
      cartItems.appendObject(cartItem)
      setUpToDefault()
      if needPost {
        sendCartItems()
      } else {
        tableView.reloadData()
      }
    } else {
      showAlertView(NSLocalizedString("select delivery type", comment: "alert title"))
    }
  }
  
  func setUpToDefault() {
    if product.productOrderableInfos.count == 1 {
      selectedProductOrderableInfo = product.productOrderableInfos.first
    } else {
      selectedProductOrderableInfo = nil
    }
    
    selectedOption = product.productOptionSets.copy() as? ProductOptionSets
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
      return cartItems.count
//      return isModifing ? 1 : cartItems.count
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
      cell.configureCell(cartItems[indexPath.row], indexPath: indexPath)
    } else if let cell = cell as? OptionCell {
      cell.delegate = self
      cell.textViewDelegate = self
      cell.configureCell(selectedOption)
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

extension OptionViewController: SchemeDelegate {
  
  func handleScheme(with id: Int) {
    product.id = id
    setUpData()
    SchemeHelper.schemeStrings.removeAtIndex(0)
    handleScheme()
  }
}