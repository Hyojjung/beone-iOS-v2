
import UIKit

class Locations: BaseListModel {
  override func getUrl() -> String {
    return "locations"
  }
  
  override func assignObject(data: AnyObject?) {
    if let locations = data as? [[String: AnyObject]] {
      list.removeAll()
      for locationObject in locations {
        let location = Location()
        location.assignObject(locationObject)
        list.appendObject(location)
      }
      if let favoredLocationId = MyInfo.sharedMyInfo().locationId,
        location = model(Int(favoredLocationId)) as? Location {
        BEONEManager.selectedLocation = location
      } else {
        BEONEManager.selectedLocation = list.first as? Location
        
      }
    }
  }
  
  func locationNames() -> [String] {
    var names = [String]()
    for location in list as! [Location] {
      if let locationName = location.name {
        names.appendObject(locationName)
      }
    }
    return names
  }
}