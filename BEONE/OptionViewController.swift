
import UIKit
import ActionSheetPicker_3_0

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
  
  var product: Product?
  var cartItems = [CartItem]()
  var selectedOption: ProductOptionSetList?
  var isModifing = false
  var isOrdering = false
  
  private var selectedProductOrderableInfo: ProductOrderableInfo?
  private var deliveryTypeNames = [String]()
  
  // MARK: - BaseViewController Methods
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUpProductData",
      name: kNotificationFetchProductSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "handlePostCartItemSuccess", name: kNotificationPostCartItemSuccess, object: nil)
  }
  
  override func setUpData() {
    super.setUpData()
    product?.fetch()
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  // MARK: - Observer Actions
  
  func setUpProductData() {
    if isModifing && cartItems.count == 1 {
      selectedProductOrderableInfo = cartItems.first!.productOrderableInfo
    } else if !isModifing {
      if product?.productOrderableInfos.count == 1 {
        selectedProductOrderableInfo = product?.productOrderableInfos.first
      }
      if product?.productOptionSets.list.count == 0 && cartItems.count == 0 {
        let cartItem = CartItem()
        cartItem.quantity = 1
        cartItems.append(cartItem)
      }
      
      selectedOption = product?.productOptionSets.copy() as? ProductOptionSetList
    }
    
    deliveryTypeNames.removeAll()
    if let product = product {
      for productOrderableInfo in product.productOrderableInfos {
        if let name = productOrderableInfo.name {
          deliveryTypeNames.append(name)
        }
      }
    }
    tableView.reloadData()
  }
  
  func handlePostCartItemSuccess() {
    if isOrdering {
      showOrderView()
    } else {
      popView()
    }
  }
}

// MARK: - Actions

extension OptionViewController {
  @IBAction func sendCart() {
    //    if let product = product, productOrderableInfo = selectedProductOrderableInfo {
    //      cartItem.product = product
    //      cartItem.productOrderableInfo = productOrderableInfo
    //      cartItem.quantity = productQuantity
    //      if cartItem == BEONEManager.selectedCartItem {
    //        cartItem.put()
    //      } else {
    //        cartItem.post()
    //      }
    //    }
  }
  
  @IBAction func selectDeliveryTypeButtonTapped() {
    if deliveryTypeNames.count > 0 {
      let deliveryTypeActionSheet =
      ActionSheetStringPicker(title: NSLocalizedString("select delivery type", comment: "picker title"),
        rows: deliveryTypeNames, initialSelection: 0, doneBlock: { (_, selectedIndex, _) -> Void in
          self.selectedProductOrderableInfo = self.product!.productOrderableInfos[selectedIndex]
          self.tableView.reloadSections(NSIndexSet(index: OptionTableViewSection.DeliveryInfo.rawValue),
            withRowAnimation: .Automatic)
        }, cancelBlock: nil, origin: view)
      deliveryTypeActionSheet.showActionSheetPicker()
    }
  }
  
  @IBAction func selectQuantityButtonTapped(sender: UIButton) {
    if cartItems.count > sender.tag {
      let cartItem = cartItems[sender.tag]
      let quantityActionSheet =
      ActionSheetStringPicker(title: NSLocalizedString("select quantity", comment: "picker title"),
        rows: kQuantityStrings, initialSelection: cartItem.quantity - 1,
        doneBlock: { (_, selectedIndex, _) -> Void in
          cartItem.quantity = selectedIndex + 1
          self.tableView.reloadSections(NSIndexSet(index: OptionTableViewSection.CartItemCount.rawValue),
            withRowAnimation: .Automatic)
        }, cancelBlock: nil, origin: view)
      quantityActionSheet.showActionSheetPicker()
    }
  }
  
  @IBAction func addCartItemButtonTapped() {
    if selectedOption == nil || selectedOption!.isValid() == true {
      let cartItem = CartItem()
      cartItem.product.id = product?.id
      cartItem.selectedOption = selectedOption?.copy() as? ProductOptionSetList
      selectedOption = product?.productOptionSets.copy() as? ProductOptionSetList
      cartItems.append(cartItem)
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
    case .CartItemCount:
      return cartItems.count
    default:
      return 1
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.cell(cellIdentifier(indexPath), indexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}


// MARK: - DynamicHeightTableViewProtocol

extension OptionViewController: DynamicHeightTableViewProtocol {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kOptionTableViewCellIdentifiers[indexPath.section]
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    switch OptionTableViewSection(rawValue: indexPath.section)! {
    case .Product:
      configureProductCell(cell)
    case .DeliveryInfo:
      configureCartItemInfoCell(cell)
    case .Button:
      configureButtonCell(cell)
    case .CartItemCount:
      configureCartItemCountCell(cell, indexPath: indexPath)
    case .Option:
      configureOptionCell(cell)
    default:
      break
    }
  }
  
  private func configureProductCell(cell: UITableViewCell) {
    if let cell = cell as? ProductCell, product = product {
      cell.configureCell(product)
    }
  }
  
  private func configureCartItemInfoCell(cell: UITableViewCell) {
    if let cell = cell as? CartItemInfoCell {
      cell.configureCell(selectedProductOrderableInfo)
    }
  }
  
  private func configureButtonCell(cell: UITableViewCell) {
    if let cell = cell as? ButtonCell {
      cell.configureCell()
    }
  }
  
  private func configureCartItemCountCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? CartItemCountCell {
      cell.configureCell(cartItems[indexPath.row], indexPath: indexPath)
    }
  }
  
  private func configureOptionCell(cell: UITableViewCell) {
    if let cell = cell as? OptionCell {
      cell.delegate = self
      cell.configureCell(selectedOption)
    }
  }
}

extension OptionViewController: OptionDelegate {
  func optionSelectButtonTapped(optionId: Int, isProductOptionSet: Bool) {
    if isProductOptionSet {
      var optionSetValues = [String]()
      var initialSelection = 0
      for (index, option) in selectedOption(optionId).options.enumerate() {
        if let name = option.name {
          optionSetValues.append(name)
        }
        if option.isSelected {
          initialSelection = index
        }
      }
      let optionActionSheet = ActionSheetStringPicker(title: NSLocalizedString("select option", comment: "picker title"),
        rows: optionSetValues,
        initialSelection: initialSelection,
        doneBlock: { (_, selectedIndex, _) -> Void in
          for (index, option) in self.selectedOption(optionId).options.enumerate() {
            option.isSelected = index == selectedIndex
          }
          self.tableView.reloadData()
        }, cancelBlock: nil,
        origin: view)
      optionActionSheet.showActionSheetPicker()
    } else {
      var selectValues = [String]()
      var initialSelection = 0
      for (index, select) in selectedOptionItem(optionId).selects.enumerate() {
        if let name = select.name {
          selectValues.append(name)
        }
        if select.name == selectedOptionItem(optionId).name {
          initialSelection = index
        }
      }
      let optionActionSheet = ActionSheetStringPicker(title: NSLocalizedString("select option", comment: "picker title"),
        rows: selectValues,
        initialSelection: initialSelection,
        doneBlock: { (_, selectedIndex, _) -> Void in
          for (index, select) in self.selectedOptionItem(optionId).selects.enumerate() {
            if index == selectedIndex {
              self.selectedOptionItem(optionId).value = select.name
            }
          }
          self.tableView.reloadData()
        }, cancelBlock: nil,
        origin: view)
      optionActionSheet.showActionSheetPicker()
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
    fatalError("no product option set")
  }
}

extension OptionViewController: UITextViewDelegate {
  func textViewDidBeginEditing(textView: UITextView) {
    if let textView = textView as? BeoneTextView {
      textView.isHighlighted = true
    }
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
      textView.isModiFying = !(textView.text == "" || textView.text == nil)
    }
  }
}