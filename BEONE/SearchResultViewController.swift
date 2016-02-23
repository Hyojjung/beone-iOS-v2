
import UIKit

class SearchResultViewController: BaseTableViewController {
  
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
  
  var isQuickOrdering = false
  
  var selectedLocation: Location = {
    if let location = BEONEManager.selectedLocation {
      return location
    }
    return Location()
  }()
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
    productList.get { () -> Void in
      self.tableView.reloadData()
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

// MAKR: - Actions

extension SearchResultViewController {
  
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
    if isQuickOrdering {
      let searchViewController = UIViewController.viewController(kMainStoryboardName, viewIdentifier: kSearchViewViewIdentifier)
      navigationController?.showViewController(searchViewController, sender: nil)
    } else {
      popView()
    }
  }
}

extension SearchResultViewController: UITableViewDataSource {
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
        isQuickOrdering: isQuickOrdering)
    } else if let cell = cell as? ProductCoupleTemplateCell {
      configureProductCell(cell, indexPath: indexPath)
    }
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return SearchTableViewSection.Count.rawValue
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == SearchTableViewSection.Product.rawValue ? (productList.list.count + 1) / kSimpleProductColumn : 1
  }
  
  private func configureProductCell(cell: UITableViewCell, indexPath: NSIndexPath) {
    if let cell = cell as? ProductCoupleTemplateCell {
      cell.configureDefaulStyle()
      var products = [Product]()
      products.append(productList.list[indexPath.row * kSimpleProductColumn] as! Product)
      if productList.list.count > indexPath.row * kSimpleProductColumn + 1 {
        products.append(productList.list[indexPath.row * kSimpleProductColumn + 1] as! Product)
      }
      cell.configureView(products)
    }
  }
}

extension SearchResultViewController: DynamicHeightTableViewProtocol {
  
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
    productProperties: [ProductProperty], tags: [Tag], minPrice: Int, maxPrice: Int, isQuickOrdering: Bool) {
      locationLabel.text = location.name
      
      let searchValueStrings = self.searchValueStrings(selectedProductPropertyValueIds,
        selectedTagIds: selectedTagIds,
        productProperties: productProperties,
        tags: tags,
        minPrice: minPrice,
        maxPrice: maxPrice)
      searchValueLabel.text = searchValueStrings.joinWithSeparator(" / ")
      
      searchButton.configureAlpha(isQuickOrdering)
  }
  
  private func searchValueStrings(selectedProductPropertyValueIds: [Int], selectedTagIds: [Int],
    productProperties: [ProductProperty], tags: [Tag], minPrice: Int, maxPrice: Int) -> [String] {
      var searchValueStrings = [String]()
      
      let priceString = "\(minPrice)~\(maxPrice)만원"
      searchValueStrings.append(priceString)
      
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
          searchValueStrings.append(productPropertyString)
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
        searchValueStrings.append(tagString)
      }
      return searchValueStrings
  }
}
