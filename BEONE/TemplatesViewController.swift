
import UIKit

class TemplatesViewController: BaseTableViewController {
  
  let templates = Templates()
  let favoriteProducts: Products = {
    let products = Products()
    products.type = .Favorite
    return products
  }()
  
  // MARK: - BaseViewController
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    templates.get {
      self.title = self.templates.title
      self.tableView.reloadData()
    }
    favoriteProducts.get {
      self.tableView.reloadData()
    }
  }
}

extension TemplatesViewController: SchemeDelegate {
  func handleScheme(with id: Int) {
    templates.id = id
    setUpData()
    SchemeHelper.schemeStrings.removeAtIndex(0)
    handleScheme()
  }
}

// MARK: - UITableViewDataSource

extension TemplatesViewController {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return templates.filterdTemplates.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    configure(cell, indexPath: indexPath)
    return cell
  }
}

extension TemplatesViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if let cellIdentifier = templates.filterdTemplates[indexPath.row].type?.cellIdentifier() {
      return cellIdentifier
    }
    fatalError("invalid template type")
  }
  
  override func configure(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? TemplateCell {
      if let cell = cell as? ProductCoupleTemplateCell {
        cell.favoriteProductDelegate = self
      } else if let cell = cell as? ProductSingleTemplateCell {
        cell.favoriteProductDelegate = self
      }
      cell.configureCell(templates.filterdTemplates[indexPath.row])
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? TemplateCell {
      return cell.calculatedHeight(templates.filterdTemplates[indexPath.row])
    }
    return nil
  }
}

extension TemplatesViewController: FavoriteProductDelegate {
  func toggleFavoriteProduct(sender: UIView, productId: Int, isFavorite: Bool) {
    tableView.reloadData()
  }
}
