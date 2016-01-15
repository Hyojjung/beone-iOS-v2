
import UIKit

class AppSetting: BaseModel {
  
  var searchMaxPrice = 50
  var searchMinPrice = 0
  var searchPriceUnit = 1
  
  override func fetchUrl() -> String {
    return "app-settings/product"
  }
  
  override func assignObject(data: AnyObject) {
    if let appSettingObject = data[kNetworkResponseKeyData] as? [String: AnyObject] {
      if let searchMaxPrice = appSettingObject["searchMaxPrice"] as? Int {
        self.searchMaxPrice = searchMaxPrice / 10000
      }
      if let searchMinPrice = appSettingObject["searchMinPrice"] as? Int {
        self.searchMinPrice = searchMinPrice / 10000
      }
      if let searchPriceUnit = appSettingObject["searchPriceUnit"] as? Int {
        self.searchPriceUnit = searchPriceUnit / 10000
      }
    }
  }
}
