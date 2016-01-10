 
 import UIKit
 
 let kSectionCellCount = 2 // delivery type cell + shop cell count
 
 class CartViewController: BaseTableViewController {
  
  @IBOutlet weak var orderButtonViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var allSelectButtonViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var allSelectButton: UIButton!
  let cartItemList = CartItemList()
  let order = Order()
  var selectedCartItemOrder = Order()
  var isWaitingSigning = false
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if !MyInfo.sharedMyInfo().isUser() {
      if isWaitingSigning {
        popView()
      } else {
        isWaitingSigning = true
        showSigningView()
      }
    }
  }
  
  override func setUpData() {
    if MyInfo.sharedMyInfo().isUser(){
      cartItemList.fetch()
    }
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchOrderableInfo",
      name: kNotificationFetchCartListSuccess, object: nil)
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
      cartItemList.selectedCartItemIds.removeAll()
      makeSelectedCartItemOrderUnique()
      selectedCartItemOrder.price = 0
      selectedCartItemOrder.orderableItemSets.removeAll()
      tableView.reloadData()
    } else {
      cartItemList.selectedCartItemIds = cartItemList.cartItemIds()
      setUpSelectedCartItemOrder()
    }
  }
  
  @IBAction func selectCartItemButtonTapped(sender: UIButton) {
    sender.selected = !sender.selected
    if !sender.selected {
      cartItemList.selectedCartItemIds.removeObject(sender.tag)
    } else {
      cartItemList.selectedCartItemIds.append(sender.tag)
    }
    setUpSelectedCartItemOrder()
  }
  
  @IBAction func removeCartItemButtonTapped(sender: AnyObject) {
    cartItemList.selectedCartItemIds.removeAll()
    cartItemList.selectedCartItemIds.append(sender.tag)
    cartItemList.delete()
  }
  
  @IBAction func removeSelectedCartItemsButtonTapped() {
    cartItemList.delete()
  }
  
  @IBAction func orderCartItemButtonTapped(sender: UIButton) {
    showOrderView([cartItem(sender.tag)])
  }
  
  @IBAction func orderSelectedCartItemButtonTapped(sender: AnyObject) {
    BEONEManager.selectedOrder = selectedCartItemOrder
//    showOrderView()
  }
  
  @IBAction func productButtonTapped(sender: AnyObject) {
    let product = Product()
    product.id = cartItem(sender.tag).product.id
    BEONEManager.selectedProduct = product
    showProductView()
  }
  
  @IBAction func optionButtonTapped(sender: AnyObject) {
    let cartItem = self.cartItem(sender.tag)
    showOptionView(cartItem.product, selectedCartItem: cartItem, isModifing: true)
  }
  
  @IBAction func segueButtonTapped() {
  }
  
  func setUpSelectedCartItemOrder() {
    makeSelectedCartItemOrderUnique()
    BEONEManager.selectedOrder = selectedCartItemOrder
    OrderHelper.fetchOrderableInfo(cartItemList.selectedCartItemIds, order: order) { self.setUpTableView() }
  }
  
  func makeSelectedCartItemOrderUnique() {
    if selectedCartItemOrder == order {
      selectedCartItemOrder = Order()
    }
  }
  
  func cartItem(cartItemId: Int) -> CartItem {
    for cartItem in cartItemList.list as! [CartItem] {
      if cartItem.id == cartItemId {
        return cartItem
      }
    }
    fatalError("no cart item with id")
  }
 }
 
 // MARK: - Observer Actions
 
 extension CartViewController {
  func fetchOrderableInfo() {
    selectedCartItemOrder = order
    if cartItemList.list.count > 0 {
      OrderHelper.fetchOrderableInfo(cartItemList.selectedCartItemIds, order: order) { self.setUpTableView() }
    } else {
      order.orderableItemSets.removeAll()
      setUpTableView()
    }
  }
  
  func setUpTableView() {
    setUpButtonView()
    allSelectButton.selected = cartItemList.selectedCartItemIds == cartItemList.cartItemIds()
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
      return orderableItemSets.orderableItems.count + kSectionCellCount
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
  
  
 }
 
 extension CartViewController: DynamicHeightTableViewProtocol {
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
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? DeliveryTypeCell {
      cell.configureCell(order.orderableItemSets[indexPath.section],
        needCell: order.deliveryTypeCellHeight(indexPath.section))
    } else if let cell = cell as? ShopNameCell {
      cell.configureCell(order.orderableItemSets[indexPath.section])
    } else if let cell = cell as? OrderableItemCell {
      let orderableItem = order.orderableItemSets[indexPath.section].orderableItems[indexPath.row - kSectionCellCount]
      cell.configureCell(orderableItem,
        cartItem: self.cartItem(orderableItem.cartItemId!),
        selectedCartItemIds: cartItemList.selectedCartItemIds)
    } else if let cell = cell as? CartPriceCell {
      cell.configureCell(selectedCartItemOrder)
    }
  }
 }
