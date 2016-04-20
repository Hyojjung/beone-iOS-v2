
import UIKit

class LandingViewController: BaseTableViewController {
  
  // MARK: - Property
  
  var templates = Templates()
  let favoriteProducts: Products = {
    let products = Products()
    products.type = .Favorite
    return products
  }()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  // MARK: - BaseViewController
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    templates.get { 
      self.tableView.reloadData()
    }
    favoriteProducts.get {
      self.tableView.reloadData()
    }
  }
  
  override func addObservers() {
    super.addObservers()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.setUpData),
      name: kNotificationGuestAuthenticationSuccess, object: nil)
  }
  
  override func removeObservers() {
    super.removeObservers()
    NSNotificationCenter.defaultCenter().removeObserver(self, name: kNotificationGuestAuthenticationSuccess, object: nil)
  }
  
  @IBAction func showSpeedOrder() {
    showViewController(.SpeedOrder)
  }
}

extension LandingViewController: SideBarPositionMoveDelegate {
  func handlemovePosition() {
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}

// MARK: - UITableViewDataSource

extension LandingViewController {
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

extension LandingViewController: DynamicHeightTableViewDelegate {
  
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

extension LandingViewController: FavoriteProductDelegate {
  func toggleFavoriteProduct(sender: UIView, productId: Int, isFavorite: Bool) {
    tableView.reloadData()
  }
}
