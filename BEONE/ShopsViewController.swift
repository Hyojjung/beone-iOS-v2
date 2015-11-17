
import UIKit

class ShopsViewController: TemplateListViewController {
  private let shopList = ShopList()
  private let kShopMargin = CGFloat(8)
  private let kCellIdentifierShopCell = "shopCell"

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
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifierShopCell , forIndexPath: indexPath)
    if let shopContentsView =
      UIView.loadFromNibName(TemplateHelper.viewNibName(TemplateType.Shop)) as? ShopContentsView {
      cell.contentView.subviews.forEach { $0.removeFromSuperview() }
      shopContentsView.configureView(shopList.list[indexPath.row] as? Shop)
      cell.contentView.addSubViewAndEnableAutoLayout(shopContentsView)
      cell.contentView.addTopLayout(shopContentsView, constant: kShopMargin)
      cell.contentView.addLeftLayout(shopContentsView, constant: kShopMargin)
      cell.contentView.addRightLayout(shopContentsView, constant: kShopMargin)
      cell.contentView.addBottomLayout(shopContentsView)
    }
    return cell
  }
}
