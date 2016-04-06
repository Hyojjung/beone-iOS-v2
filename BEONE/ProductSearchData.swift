
import UIKit

let kPriceUnit = 10000
let kDefaultPriceUnit = 1
let kDefaultMinPrice = 0
let kDefaultMaxPrice = 1000000

class ProductSearchData: BaseModel {
  
  var maxPrice = kDefaultMaxPrice
  var minPrice = kDefaultMinPrice
  var priceUnit = kDefaultPriceUnit
  var reservationDateOptions = [ReservationDateOption]()
  
  override func getUrl() -> String {
    return "app-view-data/productSearch"
  }
  
  override func assignObject(data: AnyObject?) {
    if let appSettingObject = data as? [String: AnyObject] {
      if let priceRange = appSettingObject["priceRange"] as? [String: AnyObject] {
        if let maxPrice = priceRange["maxPrice"] as? Int {
          self.maxPrice = maxPrice
        }
        if let minPrice = priceRange["minPrice"] as? Int {
          self.minPrice = minPrice
        }
        if let priceUnit = priceRange["priceUnit"] as? Int {
          self.priceUnit = priceUnit
        }
      }
      if let reservationDateOptionObjects = appSettingObject["reservationDateOptions"] as? [[String: AnyObject]] {
        reservationDateOptions.removeAll()
        for reservationDateOptionObject in reservationDateOptionObjects {
          let reservationDateOption = ReservationDateOption()
          reservationDateOption.assignObject(reservationDateOptionObject)
          reservationDateOptions.appendObject(reservationDateOption)
        }
      }
    }
  }
  
  func reservationDateOptionsNames() -> [String] {
    var reservationDateOptionsNames = [String]()
    for reservationDateOption in reservationDateOptions {
      if let name = reservationDateOption.name {
        reservationDateOptionsNames.appendObject(name)
      }
    }
    return reservationDateOptionsNames
  }
}
