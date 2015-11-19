
import UIKit

class ShopsViewController: BaseTableViewController {
  
  // MARK: - Constant

  private let kShopMargin = CGFloat(8)
  private let kShopCellIdentifier = "shopCell"

  // MARK: - Property
  
  private let shopList = ShopList()
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
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
    let cell = tableView.dequeueReusableCellWithIdentifier(kShopCellIdentifier , forIndexPath: indexPath) as! ShopCell
    if let shop = shopList.list[indexPath.row] as? Shop {
      cell.configureCell(shop)
    }
    return cell
  }
}

extension ShopsViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let shop = shopList.list[indexPath.row] as? Shop {
      BEONEManager.selectedShop = shop
      showViewController(kShopStoryboardName, viewIdentifier: kShopViewIdentifier)
    }
  }
}

class ShopCell: UITableViewCell {
  @IBOutlet weak var shopView: UIView!
  lazy var shopContentsView: ShopContentsView = {
    let shopContentsView = UIView.loadFromNibName(kShopContentsViewViewNibName) as! ShopContentsView
    return shopContentsView
  }()
  
  func configureCell(shop: Shop) {
    if shopContentsView.superview == nil {
      shopView.addSubViewAndEdgeLayout(shopContentsView)
    }
    shopContentsView.configureView(shop)
  }
}