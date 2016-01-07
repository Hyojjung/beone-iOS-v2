
import UIKit

class ShopViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum ShopTableViewSection: Int {
    case Summary
    case Product
    case Count
  }
  
  private let kShopTableViewCellIdentifiers = ["shopSummaryCell", "productCell"]
  
  // MARK: - Property
  
  var shop = BEONEManager.selectedShop
  
  lazy var shopProductList: ProductList = {
    let productList = ProductList()
    productList.type = .Shop
    return productList
  }()
  
  // MARK: - BaseViewController Methods
  
  override func setUpData() {
    super.setUpData()
    shopProductList.fetch()
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(tableView, selector: "reloadData",
      name: kNotificationFetchProductListSuccess, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "segueToOpion:",
      name: kNotificationSegueToOption, object: nil)
  }
  
  // MARK: - Observer Actions
  
  func segueToOpion(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let product = Product()
      product.id = userInfo[kNotificationKeyProductId] as? Int
      showOptionView(product, rightOrdering: true)
    }
  }
}

extension ShopViewController: DynamicHeightTableViewProtocol {
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath, forCalculateHeight: Bool) {
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

    return cell
  }
  
  private func configureSummaryCell(cell: UITableViewCell) {
    if let cell = cell as? ShopSummaryCell {
      cell.configureCell(shop)
    }
  }
  
  private func configureProductCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? ShopProductCell {
      var products = [Product]()
      products.append(shopProductList.list[indexPath.row * kSimpleProductColumn] as! Product)
      if shopProductList.list.count > indexPath.row * kSimpleProductColumn + 1 {
        products.append(shopProductList.list[indexPath.row * kSimpleProductColumn + 1] as! Product)
      }
      cell.configureCell(products)
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
    descriptionLabel.text = shop?.summary
  }
}

class ShopProductCell: UITableViewCell {
  @IBOutlet weak var productView: UIView!
  lazy var simpleProductsContentsView: SimpleProductsContentsView = {
    let productsContentsView = UIView.loadFromNibName(kSimpleProductsContentsViewNibName) as! SimpleProductsContentsView
    return productsContentsView
  }()
  
  func configureCell(products: [Product]) {
    if products.count > 0 && products.count <= kSimpleProductColumn && simpleProductsContentsView.superview == nil {
      productView.addSubViewAndEdgeLayout(simpleProductsContentsView)
    }
    simpleProductsContentsView.configureView(products)
  }
}