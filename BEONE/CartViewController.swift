 
 import UIKit
 
 let kSectionCellCount = 2 // delivery type cell + shop cell count
 
 class CartViewController: BaseTableViewController {
  @IBOutlet weak var allSelectButton: UIButton!
  let cartItemList = CartItemList()
  let order = Order()
  var selectedCartItemOrder = Order()
  
  override func setUpData() {
    cartItemList.fetch()
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchOrderableInfo",
      name: kNotificationFetchCartListSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "setUpTableView",
      name: kNotificationFetchOrderSuccess, object: nil)
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
  
  @IBAction func orderCartItemButtonTapped(sender: AnyObject) {
    showOrderView()
  }
  
  @IBAction func orderSelectedCartItemButtonTapped(sender: AnyObject) {
    BEONEManager.selectedOrder = selectedCartItemOrder
    showOrderView()
  }
  
  @IBAction func productButtonTapped(sender: AnyObject) {
    if let cartItem = cartItem(sender.tag) {
      let product = Product()
      product.id = cartItem.product.id
      BEONEManager.selectedProduct = product
      showProductView()
    }
  }
  
  @IBAction func optionButtonTapped(sender: AnyObject) {
    if let cartItem = cartItem(sender.tag) {
      showOptionView(cartItem.product, selectedCartItem: cartItem)
    }
  }
  
  @IBAction func segueButtonTapped() {
  }
  
  func setUpSelectedCartItemOrder() {
    makeSelectedCartItemOrderUnique()
    BEONEManager.selectedOrder = selectedCartItemOrder
    OrderHelper.fetchOrderableInfo(cartItemList.selectedCartItemIds)
  }
  
  func makeSelectedCartItemOrderUnique() {
    if selectedCartItemOrder == order {
      selectedCartItemOrder = Order()
    }
  }
  
  func cartItem(cartItemId: Int) -> CartItem? {
    for cartItem in cartItemList.list as! [CartItem] {
      if cartItem.id == cartItemId {
        return cartItem
      }
    }
    return nil
  }
 }
 
 // MARK: - Observer Actions
 
 extension CartViewController {
  func fetchOrderableInfo() {
    selectedCartItemOrder = order
    BEONEManager.selectedOrder = order
    OrderHelper.fetchOrderableInfo(cartItemList.selectedCartItemIds)
  }
  
  func setUpTableView() {
    allSelectButton.selected = cartItemList.selectedCartItemIds == cartItemList.cartItemIds()
    tableView.reloadData()
  }
 }
 
 extension CartViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if order.orderableItemSets.count == 0 {
      return 1
    }
    return order.orderableItemSets.count + 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section < order.orderableItemSets.count {
      let orderableItemSets = order.orderableItemSets[section]
      return orderableItemSets.orderableItems.count + kSectionCellCount
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.cell(cellIdentifier(indexPath), indexPath: indexPath)
    if let cell = cell as? DeliveryTypeImageCell {
      cell.configureCell(order.orderableItemSets[indexPath.section],
        needCell: order.deliveryTypeCellHeight(indexPath.section))
    } else if let cell = cell as? ShopNameCell {
      cell.configureCell(order.orderableItemSets[indexPath.section])
    } else if let cell = cell as? OrderableItemCell {
      cell.configureCell(order.orderableItemSets[indexPath.section].orderableItems[indexPath.row - kSectionCellCount],
        selectedCartItemIds: cartItemList.selectedCartItemIds)
    } else if let cell = cell as? OrderPriceCell {
      cell.configureCell(selectedCartItemOrder)
    }
    return cell
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if order.orderableItemSets.count == 0 {
      return "segueCell"
    } else if indexPath.section == order.orderableItemSets.count {
      return "priceCell"
    } else if indexPath.section == order.orderableItemSets.count + 1 {
      return "spaceCell"
    } else if indexPath.row == 0 {
      return kDeliveryTypeCellIdentifier
    } else if indexPath.row == 1 {
      return kShopNameCellIdentifier
    } else {
      return "productCell"
    }
  }
 }
