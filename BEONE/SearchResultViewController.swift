
import UIKit

class SearchResultViewController: ProductsViewController {

  var isSpeedOrder = false
  
  var selectedLocation: Location = {
    if let location = BEONEManager.selectedLocation {
      return location
    }
    return Location()
  }()
  
  var selectedProductPropertyValueIds = [Int]()
  var selectedTagIds = [Int]()
  var minPrice: Int?
  var maxPrice: Int?
  
  var productProperties = ProductProperties()
  var tags = Tags()
  
  override func setUpView() {
    super.setUpView()
    setUpSearchView()
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
    
    productProperties.get {
      self.setUpSearchView()
    }
    tags.get {
      self.setUpSearchView()
    }
  }
  
  private func setUpSearchView() {
    locationLabel.text = selectedLocation.name
    let searchValueStrings = self.searchValueStrings(selectedProductPropertyValueIds,
                                                     selectedTagIds: selectedTagIds,
                                                     productProperties: productProperties.list as! [ProductProperty],
                                                     tags: tags.list as! [Tag],
                                                     minPrice: minPrice,
                                                     maxPrice: maxPrice)
    if searchValueStrings.isEmpty {
      searchValueLabel.text = "검색필터를 설정해주세요."
    } else {
      searchValueLabel.text = searchValueStrings.joinWithSeparator(" / ")
    }
  }
  
  private func searchValueStrings(selectedProductPropertyValueIds: [Int], selectedTagIds: [Int],
                                  productProperties: [ProductProperty], tags: [Tag], minPrice: Int?, maxPrice: Int?) -> [String] {
    var searchValueStrings = [String]()
    
    if let minPrice = minPrice, maxPrice = maxPrice {
      let priceString = "\(minPrice / kPriceUnit) ~ \(maxPrice / kPriceUnit) 만원"
      searchValueStrings.appendObject(priceString)
    }
    
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

extension SearchResultViewController {
  @IBAction func selectLocationButtonTapped() {
    showLocationPicker(selectedLocation) { (selectedIndex) -> Void in
      self.selectedLocation = BEONEManager.sharedLocations.list[selectedIndex] as! Location
      self.products.locationId = self.selectedLocation.id
      self.products.get({
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

extension SearchResultViewController {
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == SearchTableViewSection.Product.rawValue {
      return kProductCoupleTemplateCellHeight
    }
    return ViewControllerHelper.screenHeight - 153
  }
}
