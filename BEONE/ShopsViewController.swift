
import UIKit

class ShopsViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private let kShopMargin = CGFloat(8)
  private let kShopCellIdentifier = "shopTemplateCell"
  
  // MARK: - Property
  
  private let shops = Shops()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  // MARK: - BaseViewController Methods
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
    tableView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0)
  }
  
  override func setUpData() {
    super.setUpData()
    shops.get { 
      self.tableView.reloadData()
    }
  }
  
  @IBAction func showSpeedOrder() {
    showViewController(.SpeedOrder)
  }
}

extension ShopsViewController: SideBarPositionMoveDelegate {
  func handlemovePosition() {
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}

extension ShopsViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shops.list.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    if let cell = cell as? ShopTemplateCell, shop = shops.list[indexPath.row] as? Shop {
      cell.configureView(shop)
    }
    return cell
  }
}

extension ShopsViewController: DynamicHeightTableViewDelegate {
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return 272
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kShopCellIdentifier
  }
}

extension ShopsViewController: ShopTemplateCellDelegate {
  
  func shopButtonTapped(shopId: Int) {
    for shop in shops.list as! [Shop] {
      if shopId == shop.id {
        showShopView(shop.id)
        break
      }
    }
  }
}