
import UIKit

class BEONEManager: NSObject {
  static var selectedLocation: Location? = {
    let location = Location()
    if let locationId = MyInfo.sharedMyInfo().locationId {
      location.id = Int(locationId)
      location.name = MyInfo.sharedMyInfo().locationName
    }
    return location
    }()
    {
    didSet {
      MyInfo.sharedMyInfo().locationId = BEONEManager.selectedLocation?.id
      MyInfo.sharedMyInfo().locationName = BEONEManager.selectedLocation?.name
      CoreDataHelper.sharedCoreDataHelper.saveContext()
    }
  }
  
  static var speedOrderLocationId: Int? = nil
  static var sharedLocations = Locations()
  static var globalViewContents = GlobalViewContents()
  static var selectedAddress: Address?
  static var selectedDate: NSDateComponents?
}
