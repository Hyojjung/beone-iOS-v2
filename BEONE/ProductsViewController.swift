
import UIKit

class ProductsViewController: BaseTableViewController {
  
  // MARK: - Constant
  
  private enum SearchTableViewSection: Int {
    case Search
    case Product
    case NoProducts
    case Count
  }
  
  private let kSearchTableViewCellIdentifiers = [
    "searchCell",
    "productCoupleTemplateCell",
    "noProductsCell"]
  
  // MARK: - Property
  
  var isSpeedOrder = false
  
  var selectedLocation: Location = {
    if let location = BEONEManager.selectedLocation {
      return location
    }
    return Location()
  }()
  var forSearchResult = false
  var products = Products()
  
  var selectedProductPropertyValueIds = [Int]()
  var selectedTagIds = [Int]()
  var minPrice = kDefaultMinPrice
  var maxPrice = kDefaultMaxPrice
  
  var productProperties = ProductProperties()
  var tags = Tags()
  
  override func setUpView() {
    super.setUpView()
    tableView.dynamicHeightDelgate = self
    if !forSearchResult {
      tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0)
    }
  }
  
  override func setUpData() {
    super.setUpData()
    products.noData = false
    products.isQuickOrder = false
    products.get { () -> Void in
      self.tableView.reloadData()
    }
    if forSearchResult {
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
      
      productProperties.get { () -> Void in
        self.tableView.reloadSections(NSIndexSet(index: SearchTableViewSection.Search.rawValue),
          withRowAnimation: .Automatic)
      }
      tags.get { () -> Void in
        self.tableView.reloadSections(NSIndexSet(index: SearchTableViewSection.Search.rawValue),
          withRowAnimation: .Automatic)
      } 
    }
  }
}

// MAKR: - Actions

extension ProductsViewController {
  
  @IBAction func selectLocationButtonTapped() {
    showLocationPicker(selectedLocation) { (selectedIndex) -> Void in
      self.selectedLocation = BEONEManager.sharedLocations.list[selectedIndex] as! Location
      self.products.locationId = self.selectedLocation.id
      self.products.get({ () -> Void in
        self.tableView.reloadData()
      })
    }
  }
  
  @IBAction func showSearchModalButtonTapped() {
    if isSpeedOrder {
      let searchViewController = UIViewController.viewController(kMainStoryboardName, viewIdentifier: kSearchViewIdentifier) as! SearchViewController
      searchViewController.isSpeedOrder = true
      searchViewController.products = products
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
        productProperties: productProperties.list as! [ProductProperty],
        tags: tags.list as! [Tag],
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
    } else if section == SearchTableViewSection.NoProducts.rawValue && products.list.count > 0 {
      return 0
    }
    return section == SearchTableViewSection.Product.rawValue ? (products.list.count + 1) / kSimpleProductColumn : 1
  }
  
  private func configureProductCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? ProductCoupleTemplateCell {
      cell.delegate = self
      cell.configureDefaulStyle()
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
    return kSearchTableViewCellIdentifiers[indexPath.section]
  }
  
  func calculatedHeight(cell: UITableViewCell, indexPath: NSIndexPath) -> CGFloat? {
    if indexPath.section == SearchTableViewSection.Product.rawValue {
      return 330
    } else if indexPath.section == SearchTableViewSection.NoProducts.rawValue {
      var cellHeight = ViewControllerHelper.screenHeight - 64
      if forSearchResult {
        cellHeight -= 89
      }
      return cellHeight
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
      
      let priceString = "\(minPrice / kPriceUnit)~\(maxPrice / kPriceUnit)만원"
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
