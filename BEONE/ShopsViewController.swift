
import UIKit

class ShopsViewController: MainTabViewController {
  
  // MARK: - Constant
  
  private let kShopMargin = CGFloat(8)
  private let kShopCellIdentifier = "shopTemplateCell"
  
  // MARK: - Property
  
  private let shopList = ShopList()
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    shopList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource

extension ShopsViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shopList.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    if let cell = cell as? ShopTemplateCell, shop = shopList.list[indexPath.row] as? Shop {
      cell.delegate = self
      cell.configureView(shop)
    }
    return cell
  }
}

extension ShopsViewController: DynamicHeightTableViewProtocol {
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kShopCellIdentifier
  }
}

extension ShopsViewController: ShopTemplateCellDelegate {
  
  func shopButtonTapped(shopId: Int) {
    for shop in shopList.list as! [Shop] {
      if shopId == shop.id {
        BEONEManager.selectedShop = shop
        showViewController(kShopStoryboardName, viewIdentifier: kShopViewIdentifier)
        break
      }
    }
  }
}