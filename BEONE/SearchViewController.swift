
import UIKit

class SearchViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private let kButtonAreaHeight: CGFloat = 92
  
  private enum SearchTableViewSection: Int {
    case Price
    case Tag
    case Usage
    case MoreUsageButton
    case Color
    case Count
  }
  
  private let kSearchTableViewCellIdentifiers = ["priceCell",
                                                 "searchPropertyCell",
                                                 "searchPropertyCell",
                                                 "moreUsageButtonCell",
                                                 "searchPropertyCell"]
  
  // MARK: - Property
  
  var showingMore = false
  
  var products: Products = {
    let products = Products()
    products.noData = true
    products.isQuickOrder = true
    return products
  }()
  
  var productPropertyList = ProductPropertyList()
  var tagList = TagList()
  var productSearchData = ProductSearchData()
  var isSpeedOrder = false
  
  var selectedProductPropertyValueIds = [Int]()
  var selectedTagIds = [Int]()
  var minPrice = kDefaultMinPrice
  var maxPrice = kDefaultMaxPrice
  
  @IBOutlet weak var productCountLabel: UILabel!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  override func setUpData() {
    super.setUpData()
    
    if let productPropertyValueIds = products.productPropertyValueIds {
      selectedProductPropertyValueIds = productPropertyValueIds
    }
    if let tagIds = products.tagIds {
      selectedTagIds = tagIds
    }
    if let minPrice = products.minPrice {
      self.minPrice = minPrice
    }
    if let maxPrice = products.maxPrice {
      self.maxPrice = maxPrice
    }
    
    productPropertyList.get { () -> Void in
      self.tableView.reloadData()
    }
    tagList.get { () -> Void in
      self.tableView.reloadData()
    }
    productSearchData.get { () -> Void in
      self.minPrice = self.productSearchData.minPrice
      self.maxPrice = self.productSearchData.maxPrice
      self.tableView.reloadData()
    }
    setUpProducts()
  }
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
    tableView.contentInset = UIEdgeInsetsMake(0, 0, kButtonAreaHeight, 0)
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
  
  func setUpProducts() {
    products.maxPrice = maxPrice * kPriceUnit
    products.minPrice = minPrice * kPriceUnit
    products.productPropertyValueIds = selectedProductPropertyValueIds
    products.tagIds = selectedTagIds
    products.get { () -> Void in
      if let locationName = BEONEManager.selectedLocation?.name {
        self.productCountLabel.text = "\(locationName)지역 \(self.products.total)개의 상품"
      }
    }
  }
}

// MARK: - Actions

extension SearchViewController {
  
  @IBAction func moreButtonTapped() {
    showingMore = true
    tableView.reloadData()
  }
  
  @IBAction func minPriceSelectButtonTapped(sender: UIButton) {
    selectPrice(sender, isMin: true) { (selectedValue) -> Void in
      if selectedValue != self.minPrice {
        self.minPrice = selectedValue
        if self.minPrice >= self.maxPrice {
          self.maxPrice = self.minPrice + self.productSearchData.priceUnit
        }
        self.setUpProducts()
      }
    }
  }
  
  @IBAction func maxPriceSelectButtonTapped(sender: UIButton) {
    selectPrice(sender, isMin: false) { (selectedValue) -> Void in
      if selectedValue != self.maxPrice {
        self.maxPrice = selectedValue
        if self.minPrice >= self.maxPrice {
          self.minPrice = self.maxPrice - self.productSearchData.priceUnit
        }
        self.setUpProducts()
      }
    }
  }
  
  @IBAction func searchButtonTapped() {
    if isSpeedOrder {
      popView()
    } else {
      if let searchResultViewController =
        UIViewController.viewController(kProductsStoryboardName, viewIdentifier: kProductsViewIdentifier) as? ProductsViewController {
        searchResultViewController.products = products
        searchResultViewController.selectedTagIds = selectedTagIds
        searchResultViewController.selectedProductPropertyValueIds = selectedProductPropertyValueIds
        searchResultViewController.minPrice = minPrice
        searchResultViewController.maxPrice = maxPrice
        navigationController?.showViewController(searchResultViewController, sender: nil)
      }
    }
  }
  
  func selectPrice(sender: UIButton, isMin: Bool, donBlock: (Int) -> Void) {
    var rows = [String]()
    var initialSelection = 0
    for i in 0..<((productSearchData.maxPrice - productSearchData.minPrice) / productSearchData.priceUnit) {
      let index = isMin ? i : i + 1
      let price = productSearchData.minPrice + index * productSearchData.priceUnit
      if maxPrice == price {
        initialSelection = i
      }
      rows.appendObject("\(price)")
    }
    
    let actionSheetTitle = isMin ?
      NSLocalizedString("select min price", comment: "action sheet title") :
      NSLocalizedString("select max price", comment: "action sheet title")
    showActionSheet(actionSheetTitle,
                    rows: rows,
                    initialSelection: initialSelection,
                    sender: sender,
                    doneBlock: { (_, _, selectedValue) -> Void in
                      if let selectedValue = selectedValue as? String {
                        donBlock(Int(selectedValue)!)
                      }
                      self.tableView.reloadData()
    })
  }
}

extension SearchViewController: SideBarPositionMoveDelegate {
  func handlemovePosition() {
    tableView.addGestureRecognizer(revealViewController().panGestureRecognizer())
  }
}

extension SearchViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SearchTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == SearchTableViewSection.MoreUsageButton.rawValue {
      if let productProperty = productPropertyList.list.first as? ProductProperty {
        if productProperty.values.count < kPartialValuesCount || showingMore {
          return 0
        }
      }
    }
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? SearchPropertyCell {
      if indexPath.section == SearchTableViewSection.Tag.rawValue {
        cell.configureCell(tagList.name,
                           subTitle: tagList.desc,
                           searchValues: tagList.list,
                           selectedSearchValueIds: selectedTagIds,
                           delegate: self)
      } else if let productProperty = productProperty(indexPath) {
        cell.configureCell(productProperty.name,
                           subTitle: productProperty.desc,
                           searchValues: productProperty.values,
                           selectedSearchValueIds: selectedProductPropertyValueIds,
                           delegate: self,
                           displayType: productProperty.displayType)
      }
    } else if let cell = cell as? SearchPriceCell {
      cell.configureCell(self,
                         minPrice: minPrice, maxPrice: maxPrice, minBoundPrice: productSearchData.minPrice, maxBoundPrice: productSearchData.maxPrice)
    }
    return cell
  }
  
  private func productProperty(indexPath: NSIndexPath) -> ProductProperty? {
    if indexPath.section == SearchTableViewSection.Usage.rawValue {
      if let productProperty = productPropertyList.list.first as? ProductProperty {
        if !showingMore && productProperty.values.count > kPartialValuesCount {
          return productProperty.productPropertyWithPartValues()
        } else {
          return productProperty
        }
      }
    } else if indexPath.section == SearchTableViewSection.Color.rawValue {
      if let productProperty = productPropertyList.list.last as? ProductProperty {
        return productProperty
      }
    }
    return nil
  }
}

extension SearchViewController: DynamicHeightTableViewDelegate {
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kSearchTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if let cell = cell as? SearchPropertyCell {
      if indexPath.section == SearchTableViewSection.Tag.rawValue {
        return cell.calculatedHeight(tagList.list, subTitle: tagList.desc)
      } else if let productProperty = productProperty(indexPath) {
        return cell.calculatedHeight(productProperty.values, subTitle: productProperty.desc,
                                     displayType: productProperty.displayType)
      }
    } else if cell is SearchPriceCell {
      return 180
    } else if indexPath.section == SearchTableViewSection.MoreUsageButton.rawValue {
      return 56
    }
    return nil
  }
}

extension SearchViewController: SearchValueDelegate {
  func searchValueTapped(id: Int, isTag: Bool) {
    if isTag {
      if !selectedTagIds.contains(id) {
        selectedTagIds.appendObject(id)
      } else {
        selectedTagIds.removeObject(id)
      }
    } else {
      if !selectedProductPropertyValueIds.contains(id) {
        selectedProductPropertyValueIds.appendObject(id)
      } else {
        selectedProductPropertyValueIds.removeObject(id)
      }
    }
    self.setUpProducts()
  }
}

class SearchPriceCell: SearchFilterCell {
  
  @IBOutlet weak var minPriceSelectButton: UIButton!
  @IBOutlet weak var maxPriceSelectButton: UIButton!
  
  func configureCell(delegate: AnyObject,
                     minPrice: Int?, maxPrice: Int?, minBoundPrice: Int, maxBoundPrice: Int) {
    let minPriceValue = minPrice == nil ? minBoundPrice : minPrice
    let maxPriceValue = maxPrice == nil ? maxBoundPrice : maxPrice
    
    minPriceSelectButton.setTitle("\(minPriceValue!)", forState: .Normal)
    minPriceSelectButton.setTitle("\(minPriceValue!)", forState: .Selected)
    maxPriceSelectButton.setTitle("\(maxPriceValue!)", forState: .Normal)
    maxPriceSelectButton.setTitle("\(maxPriceValue!)", forState: .Selected)
  }
}

class SearchPropertyCell: SearchFilterCell {
  
  @IBOutlet weak var valuesView: UIView!
  
  func configureCell(name: String?, subTitle: String?, searchValues: [BaseModel], selectedSearchValueIds: [Int], delegate: AnyObject,
                     displayType: ProductPropertyDisplayType? = nil) {
    nameLabel.text = name
    subTitleLabel.text = subTitle
    valuesView.subviews.forEach { $0.removeFromSuperview() }
    let productPropertyNameTypeValuesView = ProductPropertyValuesView()
    productPropertyNameTypeValuesView.layoutView(searchValues,
                                                 selectedSearchValueIds: selectedSearchValueIds, delegate: delegate, displayType: displayType)
    valuesView.addSubViewAndEdgeLayout(productPropertyNameTypeValuesView)
  }
  
  func calculatedHeight(searchValues: [BaseModel], subTitle: String?, displayType: ProductPropertyDisplayType? = nil) -> CGFloat {
    var height = 97 + Int(calculatedSubTitleHeight(subTitle))
    let rowCount = (searchValues.count - 1) / kRowValueButtonCount + 1
    let viewHeight = ProductPropertyViewHelper.buttonViewHeight(displayType)
    height += rowCount * Int(viewHeight)
    let verticalInterval = ProductPropertyViewHelper.buttonInterval(displayType)
    height += (rowCount - 1) * Int(verticalInterval)
    return CGFloat(height)
  }
}

class SearchFilterCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  
  func calculatedSubTitleHeight(description: String?) -> CGFloat {
    let descriptionLabel = UILabel()
    descriptionLabel.font = UIFont.systemFontOfSize(13)
    descriptionLabel.text = description
    descriptionLabel.setWidth(ViewControllerHelper.screenWidth - 24)
    return descriptionLabel.frame.height
  }
}