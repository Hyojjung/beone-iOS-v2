
import UIKit

class LocationList: BaseListModel {
  override func fetchUrl() -> String {
    return "locations"
  }
  
  override func assignObject(data: AnyObject) {
    if let locationList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      list.removeAll()
      for locationObject in locationList {
        let location = Location()
        location.assignObject(locationObject)
        list.append(location)
      }
      BEONEManager.selectedLocation = list.first as? Location
    }
  }
  
  func locationNames() -> [String] {
    var names = [String]()
    for location in list as! [Location] {
      if let locationName = location.name {
        names.append(locationName)
      }
    }
    return names
  }
}
