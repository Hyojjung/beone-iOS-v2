
import UIKit

class AppSetting: BaseModel {
  
  var searchMaxPrice: Int?
  var searchMinPrice = 0
  var searchPriceUnit = 10000
  
  override func fetchUrl() -> String {
    return "app-settings/product"
  }
  
  override func assignObject(data: AnyObject) {
    if let appSettingObject = data[kNetworkResponseKeyData] as? [String: AnyObject] {
      searchMaxPrice = appSettingObject["searchMaxPrice"] as? Int
      if let searchMinPrice = appSettingObject["searchMinPrice"] as? Int {
        self.searchMinPrice = searchMinPrice
      }
      if let searchPriceUnit = appSettingObject["searchPriceUnit"] as? Int {
        self.searchPriceUnit = searchPriceUnit
      }
    }
  }
}
