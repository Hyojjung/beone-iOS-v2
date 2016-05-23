
import UIKit

class CategoriesViewController: BaseTableViewController {
  
  var categories = ProductCategories()

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    categories.get { 
      self.tableView.reloadData()
    }
  }
  
  @IBAction func showSpeedOrder() {
    showViewController(.SpeedOrder)
  }
  
  @IBAction func categoryButtonTapped(sender: UIButton) {
    if let category = categories.model(sender.tag) as? ProductCategory {
      if let categoryProductsViewController = UIViewController.viewController(.Products) as? ProductsViewController {
        categoryProductsViewController.title = category.name
        categoryProductsViewController.products.type = .Category
        categoryProductsViewController.products.productCategoryId = category.id
        showViewController(categoryProductsViewController, sender: nil)
      }
    }
  }
}

extension CategoriesViewController: SideBarPositionMoveDelegate {
  func handlemovePosition() {
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}

extension CategoriesViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return categories.list.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? CategoryCell {
      cell.configureCell(categories.list[indexPath.row] as! ProductCategory)
    }
    return cell
  }
}

extension CategoriesViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    if indexPath.section == 0 {
      return "imageCell"
    } else if indexPath.row % 2 == 0 {
      return "categoryLeftCell"
    } else {
      return "categoryRightCell"
    }
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if indexPath.section == 0 {
      return 13 / 32 * ViewControllerHelper.screenWidth
    } else {
      return 15 / 32 * ViewControllerHelper.screenWidth
    }
  }
}

class CategoryCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var firstProductImageView: LazyLoadingImageView!
  @IBOutlet weak var secondProductImageView: LazyLoadingImageView!
  @IBOutlet weak var thirdProductImageView: LazyLoadingImageView!
  @IBOutlet weak var forthProductImageView: LazyLoadingImageView!
  @IBOutlet weak var categoryButton: UIButton!
  
  func configureCell(category: ProductCategory) {
    categoryButton.tag = category.id!
    nameLabel.text = category.name
    summaryLabel.text = category.desc
    setLazyLoaingImage(firstProductImageView, products: category.products, index: 0)
    setLazyLoaingImage(secondProductImageView, products: category.products, index: 1)
    setLazyLoaingImage(thirdProductImageView, products: category.products, index: 2)
    setLazyLoaingImage(forthProductImageView, products: category.products, index: 3)
  }
  
  private func setLazyLoaingImage(imageView: LazyLoadingImageView, products: Products, index: Int) {
    let product = products.list.objectAtIndex(index) as? Product
    imageView.image = UIImage(named: kimagePostThumbnail)
    imageView.setLazyLoaingImage(product?.mainImageUrl)
  }
}