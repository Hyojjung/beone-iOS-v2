
import UIKit
import ActionSheetPicker_3_0

class OptionViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum OptionTableViewSection: Int {
    case Product
    case CartItemInfo
    case Button
    case Count
  }
  
  private let kOptionTableViewCellIdentifiers = ["productCell", "cartItemInfoCell", "buttonCell"]
  private let kQuantityStrings = ["1", "2", "3", "4", "5"]
  
  // MARK: - Property
  
  private var product = BEONEManager.selectedProduct
  private var selectedProductOrderableInfo: ProductOrderableInfo?
  private var deliveryTypeNames = [String]()
  private var productQuantity = 1
  
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
  
  // MARK: - Observer Actions
  
  func setUpProductData() {
    if product?.productOrderableInfos.count == 1 {
      selectedProductOrderableInfo = product?.productOrderableInfos.first
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
    if BEONEManager.ordering {
      showViewController(kOrderStoryboardName, viewIdentifier: kOrderAddressViewIdentifier)
    } else {
      popView()
    }
  }
}

// MARK: - Actions

extension OptionViewController {
  @IBAction func sendCart() {
    if let product = product, productOrderableInfo = selectedProductOrderableInfo {
      let cartItem = CartItem()
      cartItem.productId = product.id
      cartItem.productOrderableInfoId = productOrderableInfo.id
      cartItem.quantity = productQuantity
      cartItem.post()
    }
  }
  
  @IBAction func selectDeliveryTypeButtonTapped() {
    if deliveryTypeNames.count > 0 {
      let deliveryTypeActionSheet =
      ActionSheetStringPicker(title: NSLocalizedString("select delivery type", comment: "picker title"),
        rows: deliveryTypeNames, initialSelection: 0, doneBlock: { (_, selectedIndex, _) -> Void in
          self.selectedProductOrderableInfo = self.product!.productOrderableInfos[selectedIndex]
          self.tableView.reloadSections(NSIndexSet(index: OptionTableViewSection.CartItemInfo.rawValue),
            withRowAnimation: .Automatic)
        }, cancelBlock: nil, origin: view)
      deliveryTypeActionSheet.showActionSheetPicker()
    }
  }
  
  @IBAction func selectQuantityButtonTapped() {
    let quantityActionSheet =
    ActionSheetStringPicker(title: NSLocalizedString("select quantity", comment: "picker title"),
      rows: kQuantityStrings, initialSelection: 0, doneBlock: { (_, selectedIndex, _) -> Void in
        self.productQuantity = selectedIndex + 1
        self.tableView.reloadSections(NSIndexSet(index: OptionTableViewSection.CartItemInfo.rawValue),
          withRowAnimation: .Automatic)
      }, cancelBlock: nil, origin: view)
    quantityActionSheet.showActionSheetPicker()
  }
}

// MARK: - UITableViewDataSource

extension OptionViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return OptionTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kOptionTableViewCellIdentifiers[indexPath.section],
      forIndexPath: indexPath)
    switch OptionTableViewSection(rawValue: indexPath.section)! {
    case .Product:
      configureProductCell(cell)
    case .CartItemInfo:
      configureCartItemInfoCell(cell)
    case .Button:
      configureButtonCell(cell)
    default:
      break
    }
    return cell
  }
  
  private func configureProductCell(cell: UITableViewCell) {
    if let cell = cell as? ProductCell, product = product {
      cell.configureCell(product)
    }
  }
  
  private func configureCartItemInfoCell(cell: UITableViewCell) {
    if let cell = cell as? CartItemInfoCell {
      cell.configureCell(selectedProductOrderableInfo, quantity: productQuantity)
    }
  }
  
  private func configureButtonCell(cell: UITableViewCell) {
    if let cell = cell as? ButtonCell {
      cell.configureCell()
    }
  }
}
