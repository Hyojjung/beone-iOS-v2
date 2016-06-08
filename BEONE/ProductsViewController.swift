
import UIKit

class ProductsViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  enum SearchTableViewSection: Int {
    case Product
    case NoProducts
    case Count
  }
  
  private let kSearchTableViewCellIdentifiers = [
    "productCoupleTemplateCell",
    "noProductsCell"]
  
  // MARK: - Property
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var searchValueLabel: UILabel!
  
  var products = Products()
  let favoriteProducts: Products = {
    let products = Products()
    products.type = .Favorite
    return products
  }()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
    tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0)
    tableView.registerNib(UINib(nibName: kProductCoupleTemplateCellIdentifier.convertToBigCamelCase(), bundle: nil),
                          forCellReuseIdentifier: kProductCoupleTemplateCellIdentifier)
  }
  
  override func setUpData() {
    super.setUpData()
    favoriteProducts.get {
      self.tableView.reloadData()
    }
    products.get {
      self.tableView.reloadData()
    }
    showingLoadingView = false
  }
}

// MAKR: - Actions

extension ProductsViewController: FavoriteProductDelegate {
  func toggleFavoriteProduct(sender: UIView, productId: Int, isFavorite: Bool) {
    if !isFavorite {
      if products.type == .Favorite {
        products.list = products.list.filter { ($0 as! Product).id != productId  }
      }
      self.tableView.reloadData()
    }
  }
}

extension ProductsViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? ProductCoupleTemplateCell {
      configureProductCell(cell, indexPath: indexPath)
    }
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SearchTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == SearchTableViewSection.NoProducts.rawValue && products.list.count > 0 {
      return 0
    }
    return section == SearchTableViewSection.Product.rawValue ? (products.list.count + 1) / kSimpleProductColumn : 1
  }
  
  private func configureProductCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? ProductCoupleTemplateCell {
      cell.configureDefaulStyle()
      cell.favoriteProductDelegate = self;
      var products = [Product]()
      let index = indexPath.row * kSimpleProductColumn
      products.appendObject(self.products.list.objectAtIndex(index) as? Product)
      products.appendObject(self.products.list.objectAtIndex(index + 1) as? Product)
      cell.configureView(products)
    }
  }
}

extension ProductsViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if indexPath.section == SearchTableViewSection.NoProducts.rawValue {
      switch products.type {
      case .Recent:
        return "noRecentProductsCell"
      case .Favorite:
        return "noFavoriteProductsCell"
      default: break
      }
    }
    return kSearchTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    return nil
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == SearchTableViewSection.Product.rawValue {
      return kProductCoupleTemplateCellHeight
    }
    return ViewControllerHelper.screenHeight - 64
  }
}
