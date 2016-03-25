
import UIKit

class BEONEManager: NSObject {
  static var selectedLocation: Location?
  static var sharedLocationList = LocationList()
  static var globalViewContents = GlobalViewContents()
  static var selectedAddress: Address?
  static var selectedDate: NSDateComponents?
}
