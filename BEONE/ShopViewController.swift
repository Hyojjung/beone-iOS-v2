
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
  lazy var shopProducts: Products = {
    let products = Products()
    products.type = .Shop
    products.shopId = self.shop.id
    return products
  }()
  
  // MARK: - BaseViewController Methods
  
  override func setUpData() {
    super.setUpData()
    shop.get({ () -> Void in
      self.tableView.reloadData()
    })
    shopProducts.get { () -> Void in
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
      return cell.calculatedHeight(shop)
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
      1 : (shopProducts.list.count + 1) / kSimpleProductColumn
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
      let index = indexPath.row * kSimpleProductColumn
      products.appendObject(shopProducts.list.objectAtIndex(index) as? Product)
      products.appendObject(shopProducts.list.objectAtIndex(index + 1) as? Product)
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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileImageView.makeCircleView()
  }
  
  func configureCell(shop: Shop?) {
    backgroundImageView.setLazyLoaingImage(shop?.backgroundImageUrl)
    profileImageView.setLazyLoaingImage(shop?.profileImageUrl)
    nameLabel.text = shop?.name
    descriptionLabel.text = shop?.desc
    tagLabel.text = shop?.tagString()
  }
  
  func calculatedHeight(shop: Shop) -> CGFloat {
    let descrtiptionLabel = UILabel()
    descrtiptionLabel.font = UIFont.systemFontOfSize(14)
    descrtiptionLabel.text = shop.desc
    descrtiptionLabel.setWidth(ViewControllerHelper.screenWidth - 76)
    
    let tagLabel = UILabel()
    tagLabel.font = UIFont.systemFontOfSize(13)
    tagLabel.text = shop.tagString()
    tagLabel.setWidth(ViewControllerHelper.screenWidth - 76)
    return 339 + descrtiptionLabel.frame.height + tagLabel.frame.height
  }
}
