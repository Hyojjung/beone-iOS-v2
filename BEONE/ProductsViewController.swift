
import UIKit

class ProductsViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SearchTableViewSection: Int {
    case Search
    case Product
    case Count
  }
  
  private let kSearchTableViewCellIdentifiers = [
    "searchCell",
    "productCoupleTemplateCell"]
  
  // MARK: - Property
  
  var isSpeedOrder = false
  
  var selectedLocation: Location = {
    if let location = BEONEManager.selectedLocation {
      return location
    }
    return Location()
  }()
  var forSearchResult = false
  var productList = ProductList()
  
  var selectedProductPropertyValueIds = [Int]()
  var selectedTagIds = [Int]()
  var minPrice = kDefaultMinPrice
  var maxPrice = kDefaultMaxPrice
  
  var productPropertyList = ProductPropertyList()
  var tagList = TagList()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
  }
  
  override func setUpData() {
    super.setUpData()
    productList.noData = false
    productList.isQuickOrder = false
    productList.get { () -> Void in
      self.tableView.reloadData()
    }
    if forSearchResult {
      if let productPropertyValueIds = productList.productPropertyValueIds {
        selectedProductPropertyValueIds = productPropertyValueIds
      }
      if let tagIds = productList.tagIds {
        selectedTagIds = tagIds
      }
      if let minPrice = productList.minPrice {
        self.minPrice = minPrice / kPriceUnit
      }
      if let maxPrice = productList.maxPrice {
        self.maxPrice = maxPrice / kPriceUnit
      }
      
      productPropertyList.get { () -> Void in
        self.tableView.reloadSections(NSIndexSet(index: SearchTableViewSection.Search.rawValue),
          withRowAnimation: .Automatic)
      }
      tagList.get { () -> Void in
        self.tableView.reloadSections(NSIndexSet(index: SearchTableViewSection.Search.rawValue),
          withRowAnimation: .Automatic)
      } 
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setUpData()
  }
}

// MAKR: - Actions

extension ProductsViewController {
  
  @IBAction func selectLocationButtonTapped() {
    showLocationPicker(selectedLocation) { (selectedIndex) -> Void in
      self.selectedLocation = BEONEManager.sharedLocationList.list[selectedIndex] as! Location
      self.productList.locationId = self.selectedLocation.id
      self.productList.get({ () -> Void in
        self.tableView.reloadData()
      })
    }
  }
  
  @IBAction func showSearchModalButtonTapped() {
    if isSpeedOrder {
      let searchViewController = UIViewController.viewController(kMainStoryboardName, viewIdentifier: kSearchViewIdentifier) as! SearchViewController
      searchViewController.isSpeedOrder = true
      searchViewController.productList = productList
      navigationController?.showViewController(searchViewController, sender: nil)
    } else {
      popView()
    }
  }
}

extension ProductsViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier(indexPath), forIndexPath: indexPath)
    if let cell = cell as? SearchCell {
      cell.configureCell(selectedLocation,
        selectedProductPropertyValueIds: selectedProductPropertyValueIds,
        selectedTagIds: selectedTagIds,
        productProperties: productPropertyList.list as! [ProductProperty],
        tags: tagList.list as! [Tag],
        minPrice: minPrice,
        maxPrice: maxPrice,
        isSpeedOrder: isSpeedOrder)
    } else if let cell = cell as? ProductCoupleTemplateCell {
      configureProductCell(cell, indexPath: indexPath)
    }
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SearchTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == SearchTableViewSection.Search.rawValue && !forSearchResult {
      return 0
    }
    return section == SearchTableViewSection.Product.rawValue ? (productList.list.count + 1) / kSimpleProductColumn : 1
  }
  
  private func configureProductCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? ProductCoupleTemplateCell {
      cell.delegate = self
      cell.configureDefaulStyle()
      var products = [Product]()
      let index = indexPath.row * kSimpleProductColumn
      products.appendObject(productList.list.objectAtIndex(index) as? Product)
      products.appendObject(productList.list.objectAtIndex(index + 1) as? Product)
      cell.configureView(products)
    }
  }
}

extension ProductsViewController: DynamicHeightTableViewDelegate {
  
  func cellIdentifier(indexPath: NSIndexPath) -> String {
    return kSearchTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if indexPath.section == SearchTableViewSection.Product.rawValue {
      return 330
    }
    return 89
  }
}

class SearchCell: UITableViewCell {
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var searchValueLabel: UILabel!
  @IBOutlet weak var searchButton: UIButton!
  
  func configureCell(location: Location, selectedProductPropertyValueIds: [Int], selectedTagIds: [Int],
    productProperties: [ProductProperty], tags: [Tag], minPrice: Int, maxPrice: Int, isSpeedOrder: Bool) {
      locationLabel.text = location.name
      
      let searchValueStrings = self.searchValueStrings(selectedProductPropertyValueIds,
        selectedTagIds: selectedTagIds,
        productProperties: productProperties,
        tags: tags,
        minPrice: minPrice,
        maxPrice: maxPrice)
      searchValueLabel.text = searchValueStrings.joinWithSeparator(" / ")
      
      searchButton.configureAlpha(isSpeedOrder)
  }
  
  private func searchValueStrings(selectedProductPropertyValueIds: [Int], selectedTagIds: [Int],
    productProperties: [ProductProperty], tags: [Tag], minPrice: Int, maxPrice: Int) -> [String] {
      var searchValueStrings = [String]()
      
      let priceString = "\(minPrice)~\(maxPrice)만원"
      searchValueStrings.appendObject(priceString)
      
      for productProperty in productProperties {
        var productPropertyString = String()
        for productPropertyValue in productProperty.values {
          if selectedProductPropertyValueIds.contains(productPropertyValue.id!) {
            if !productPropertyString.isEmpty {
              productPropertyString += ", "
            }
            productPropertyString += productPropertyValue.name!
          }
        }
        if !productPropertyString.isEmpty {
          searchValueStrings.appendObject(productPropertyString)
        }
      }
      
      var tagString = String()
      for tag in tags {
        if selectedTagIds.contains(tag.id!) {
          if !tagString.isEmpty {
            tagString += ", "
          }
          tagString += tag.name!
        }
      }
      if !tagString.isEmpty {
        searchValueStrings.appendObject(tagString)
      }
      return searchValueStrings
  }
}
