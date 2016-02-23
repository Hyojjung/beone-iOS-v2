
import UIKit

class CategoryListViewController: BaseTableViewController {
  
  var categoryList = ProductCategoryList()
  
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
    categoryList.get { () -> Void in
     self.tableView.reloadData()
    }
  }
  
  @IBAction func categoryButtonTapped(sender: UIButton) {
    if let category = categoryList.model(sender.tag) as? ProductCategory {
      // TODO: Category List 로 가기
    }
  }
}

extension CategoryListViewController: SideBarPositionMoveDelegate {
  func handlemovePosition() {
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}

extension CategoryListViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      return categoryList.list.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? CategoryCell {
      cell.configureCell(categoryList.list[indexPath.row] as! ProductCategory)
    }
    return cell
  }
}

extension CategoryListViewController: DynamicHeightTableViewProtocol {
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
    setLazyLoaingImage(firstProductImageView, productList: category.products, index: 0)
    setLazyLoaingImage(secondProductImageView, productList: category.products, index: 1)
    setLazyLoaingImage(thirdProductImageView, productList: category.products, index: 2)
    setLazyLoaingImage(forthProductImageView, productList: category.products, index: 3)
  }
  
  private func setLazyLoaingImage(imageView: LazyLoadingImageView, productList: ProductList, index: Int) {
    if productList.list.count > index {
      let product = productList.list[index] as! Product
      imageView.setLazyLoaingImage(product.mainImageUrl)
    }
  }
}