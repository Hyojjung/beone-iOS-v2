
import UIKit

class BEONEManager: NSObject {
  static var selectedLocation: Location? {
    didSet {
      MyInfo.sharedMyInfo().locationId = BEONEManager.selectedLocation?.id
      MyInfo.sharedMyInfo().locationName = BEONEManager.selectedLocation?.name
      CoreDataHelper.sharedCoreDataHelper.saveContext()
    }
  }
  static var sharedLocationList = LocationList()
  static var globalViewContents = GlobalViewContents()
  static var selectedAddress: Address?
  static var selectedDate: NSDateComponents?
}
