
import UIKit

class ShopsViewController: BaseTableViewController {
  
  // MARK: - Constant

  private let kShopMargin = CGFloat(8)
  private let kShopCellIdentifier = "shopTemplateCell"

  // MARK: - Property
  
  private let shopList = ShopList()
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
    shopList.fetch()
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(tableView, selector: "reloadData",
      name: kNotificationFetchShopListSuccess, object: nil)
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
      cell.configureCell(shop)
    }
    return cell
  }
}

extension ShopsViewController: DynamicHeightTableViewProtocol {
  
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