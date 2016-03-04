 
 import UIKit
 
 class CartViewController: BaseTableViewController {
  
  @IBOutlet weak var orderButtonViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var allSelectButtonViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var allSelectButton: UIButton!
  
  let cartItemList = CartItemList()
  let order: Order = {
    let order = Order()
    order.isDone = false
    return order
  }()
  let selectedCartItemOrder: Order = {
    let order = Order()
    order.isDone = false
    return order
  }()
  
  override func setUpData() {
    if MyInfo.sharedMyInfo().isUser(){
      cartItemList.get({ () -> Void in
        self.fetchOrderableInfo()
      })
    }
  }
  
  override func setUpView() {
    super.setUpView()
    setUpButtonView()
    tableView.dynamicHeightDelgate = self
  }
 }
 
 // MARK: - Actions
 
 extension CartViewController {
  @IBAction func selectAllButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
    if !sender.selected {
      selectedCartItemOrder.cartItemIds.removeAll()
    } else {
      selectedCartItemOrder.cartItemIds = CartItemManager.cartItemIds(cartItemList.list)
    }
    setUpSelectedCartItemOrder()
  }
  
  @IBAction func selectCartItemButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
    if !sender.selected {
      selectedCartItemOrder.cartItemIds.removeObject(sender.tag)
    } else {
      selectedCartItemOrder.cartItemIds.append(sender.tag)
    }
    setUpSelectedCartItemOrder()
  }
  
  @IBAction func removeCartItemButtonTapped(sender: AnyObject) {
    deleteCartItem([sender.tag])
  }
  
  @IBAction func removeSelectedCartItemsButtonTapped() {
    deleteCartItem(selectedCartItemOrder.cartItemIds)
  }
  
  func deleteCartItem(cartItemIds: [Int]) {
    CartItemManager.removeCartItem(cartItemIds) { () -> Void in
      self.setUpData()
    }
  }
  
  @IBAction func orderCartItemButtonTapped(sender: UIButton) {
    showOrderView([sender.tag])
  }
  
  @IBAction func orderSelectedCartItemButtonTapped(sender: AnyObject) {
    showOrderView(selectedCartItemOrder.cartItemIds)
  }
  
  @IBAction func productButtonTapped(sender: AnyObject) {
    showProductView(cartItem(sender.tag).product.id)
  }
  
  @IBAction func optionButtonTapped(sender: AnyObject) {
    let cartItem = self.cartItem(sender.tag)
    showOptionView(cartItem.product.id, selectedCartItem: cartItem, isModifing: true)
  }
  
  @IBAction func segueButtonTapped() {
    popView()
  }
  
  @IBAction func minusButtonTapped(sender: UIButton) {
    let cartItem = self.cartItem(sender.tag)
    if cartItem.quantity > 1 {
      cartItem.quantity -= 1
      cartItem.put({ (_) -> Void in
        self.configureCartItemQuantity(cartItem)
        self.tableView.reloadData()
        }, putFailure: { (_) -> Void in
          cartItem.quantity += 1
      })
    }
  }
  
  @IBAction func addButtonTapped(sender: UIButton) {
    let cartItem = self.cartItem(sender.tag)
    cartItem.quantity += 1
    cartItem.put({ (_) -> Void in
      self.configureCartItemQuantity(cartItem)
      self.tableView.reloadData()
      }, putFailure: { (_) -> Void in
        cartItem.quantity -= 1
    })
  }
  
  func configureCartItemQuantity(cartItem: CartItem) {
    for orderableItemSet in order.orderableItemSets {
      for orderableItem in orderableItemSet.orderableItemList.list as! [OrderableItem] {
        if orderableItem.cartItemId == cartItem.id {
          orderableItem.quantity = cartItem.quantity
        }
      }
    }
  }
  
  func setUpSelectedCartItemOrder() {
    if selectedCartItemOrder.cartItemIds.count == 0 {
      selectedCartItemOrder.actualPrice = 0
      selectedCartItemOrder.orderableItemSets.removeAll()
      tableView.reloadData()
    } else {
      OrderHelper.fetchOrderableInfo(selectedCartItemOrder) { self.setUpTableView() }
    }
  }
  
  func cartItem(cartItemId: Int) -> CartItem {
    return cartItemList.model(cartItemId) as! CartItem
  }
 }
 
 // MARK: - Observer Actions
 
 extension CartViewController {
  func fetchOrderableInfo() {
    order.cartItemIds = CartItemManager.cartItemIds(cartItemList.list)
    selectedCartItemOrder.cartItemIds = CartItemManager.cartItemIds(cartItemList.list)
    
    if cartItemList.list.count > 0 {
      OrderHelper.fetchOrderableInfo(order) {
        self.selectedCartItemOrder.actualPrice = self.order.actualPrice
        self.selectedCartItemOrder.orderableItemSets = self.order.orderableItemSets
        self.setUpTableView()
      }
    } else {
      order.orderableItemSets.removeAll()
      setUpTableView()
    }
  }
  
  func setUpTableView() {
    setUpButtonView()
    allSelectButton.selected =
      selectedCartItemOrder.cartItemIds.hasEqualObjects(CartItemManager.cartItemIds(cartItemList.list))
    tableView.reloadData()
  }
  
  func setUpButtonView() {
    allSelectButtonViewTopConstraint.constant = order.orderableItemSets.count == 0 ? -45 : 0
    orderButtonViewBottomConstraint.constant = order.orderableItemSets.count == 0 ? -49 : 0
  }
 }
 
 extension CartViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if order.orderableItemSets.count == 0 {
      return 1
    }
    return order.orderableItemSets.count + 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section < order.orderableItemSets.count {
      let orderableItemSets = order.orderableItemSets[section]
      return orderableItemSets.orderableItemList.list.count + kSectionCellCount
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
 }
 
 extension CartViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if order.orderableItemSets.count == 0 {
      return "segueCell"
    } else if indexPath.section == order.orderableItemSets.count {
      return "priceCell"
    } else if indexPath.row == 0 {
      return kDeliveryTypeCellIdentifier
    } else if indexPath.row == 1 {
      return kShopNameCellIdentifier
    } else {
      return "productCell"
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? DeliveryTypeCell {
      return cell.calculatedHeight(order.deliveryTypeCellHeight(indexPath.section))
    } else if let cell = cell as? CartOrderableItemCell,
      orderItems = order.orderableItemSets[indexPath.section].orderableItemList.list as? [OrderableItem] {
        let orderableItem = orderItems[indexPath.row - kSectionCellCount]
        return cell.calculatedHeight(orderableItem, selectedOption: orderableItem.selectedOption)
    } else if cell is CartPriceCell {
      return 174
    }
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? DeliveryTypeCell {
      cell.configureCell(order.orderableItemSets[indexPath.section],
        needCell: order.deliveryTypeCellHeight(indexPath.section))
    } else if let cell = cell as? ShopNameCell {
      cell.configureCell(order.orderableItemSets[indexPath.section])
    } else if let cell = cell as? CartOrderableItemCell,
      orderItems = order.orderableItemSets[indexPath.section].orderableItemList.list as? [OrderableItem] {
      let orderableItem = orderItems[indexPath.row - kSectionCellCount]
      cell.configureCell(orderableItem,
        selectedOption: orderableItem.selectedOption,
        selectedCartItemIds: selectedCartItemOrder.cartItemIds)
    } else if let cell = cell as? CartPriceCell {
      cell.configureCell(selectedCartItemOrder)
    }
  }
 }
