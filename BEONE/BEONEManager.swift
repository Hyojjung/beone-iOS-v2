
import UIKit

class BEONEManager: NSObject {
  static var rightOrdering = false // 바로구매 중인지
  
  static var selectedShop: Shop?
  static var selectedCartItem: CartItem?
  static var selectedLocation: Location?
  static var sharedLocationList = LocationList()
}
