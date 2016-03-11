
import UIKit

class ShopViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum ShopTableViewSection: Int {
    case Summary
    case Product
    case Count
  }
  
  private let kShopTableViewCellIdentifiers = ["shopSummaryCell", "productCoupleTemplateCell"]
  
  // MARK: - Property
  
  var shop = Shop()
  lazy var shopProductList: ProductList = {
    let productList = ProductList()
    productList.type = .Shop
    return productList
  }()
  
  // MARK: - BaseViewController Methods
  
  override func setUpData() {
    super.setUpData()
    shop.get({ () -> Void in
      self.tableView.reloadData()
    })
    shopProductList.get { () -> Void in
      self.tableView.reloadData()
    }
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  // MARK: - Observer Actions
  
  func segueToOpion(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      showOptionView(userInfo[kNotificationKeyProductId] as? Int, rightOrdering: true)
    }
  }
}

extension ShopViewController: DynamicHeightTableViewDelegate {
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? ShopSummaryCell {
      return cell.calculatedHeight(shop.desc)
    }
    return nil
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    switch ShopTableViewSection(rawValue: indexPath.section)! {
    case .Summary:
      configureSummaryCell(cell)
    case .Product:
      configureProductCell(cell, indexPath: indexPath)
    default:
      break
    }
  }
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kShopTableViewCellIdentifiers[indexPath.section]
  }
}

extension ShopViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return ShopTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == ShopTableViewSection.Summary.rawValue ?
      1 : (shopProductList.list.count + 1) / kSimpleProductColumn
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath) , forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
  
  private func configureSummaryCell(cell: UITableViewCell) {
    if let cell = cell as? ShopSummaryCell {
      cell.configureCell(shop)
    }
  }
  
  private func configureProductCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? ProductCoupleTemplateCell {
      cell.delegate = self
      cell.configureDefaulStyle()
      var products = [Product]()
      products.append(shopProductList.list[indexPath.row * kSimpleProductColumn] as! Product)
      if shopProductList.list.count > indexPath.row * kSimpleProductColumn + 1 {
        products.append(shopProductList.list[indexPath.row * kSimpleProductColumn + 1] as! Product)
      }
      cell.configureView(products)
    }
  }
}

class ShopSummaryCell: UITableViewCell {
  @IBOutlet weak var backgroundImageView: LazyLoadingImageView!
  @IBOutlet weak var profileImageView: LazyLoadingImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var tagLabel: UILabel!
  
  func configureCell(shop: Shop?) {
    backgroundImageView.setLazyLoaingImage(shop?.backgroundImageUrl)
    profileImageView.setLazyLoaingImage(shop?.profileImageUrl)
    profileImageView.makeCircleView()
    nameLabel.text = shop?.name
    descriptionLabel.text = shop?.desc
  }
  
  func calculatedHeight(shopDescription: String?) -> CGFloat {
    let descrtiptionLabel = UILabel()
    descrtiptionLabel.font = UIFont.systemFontOfSize(14)
    descrtiptionLabel.text = shopDescription
    descrtiptionLabel.setWidth(ViewControllerHelper.screenWidth - 76)
    return 355 + descrtiptionLabel.frame.height
  }
}
