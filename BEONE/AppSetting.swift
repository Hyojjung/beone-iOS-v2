
import UIKit

let kPriceUnit = 10000
let kDefaultMinPrice = 0
let kDefaultMaxPrice = 50

class AppSetting: BaseModel {
  
  var searchMaxPrice = kDefaultMaxPrice
  var searchMinPrice = kDefaultMinPrice
  var searchPriceUnit = 1
  
  override func fetchUrl() -> String {
    return "app-settings/product"
  }
  
  override func assignObject(data: AnyObject) {
    if let appSettingObject = data as? [String: AnyObject] {
      if let searchMaxPrice = appSettingObject["searchMaxPrice"] as? Int {
        self.searchMaxPrice = searchMaxPrice / kPriceUnit
      }
      if let searchMinPrice = appSettingObject["searchMinPrice"] as? Int {
        self.searchMinPrice = searchMinPrice / kPriceUnit
      }
      if let searchPriceUnit = appSettingObject["searchPriceUnit"] as? Int {
        self.searchPriceUnit = searchPriceUnit / kPriceUnit
      }
    }
  }
}
