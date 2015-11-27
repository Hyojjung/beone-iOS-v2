
import UIKit

class BEONEManager: NSObject {
  static var ordering = false // 구매 중인지
  static var rightOrdering = false // 바로구매 중인지
  
  static var selectedShop: Shop?
  static var selectedProduct: Product?
  static var selectedLocation: Location?
  static var sharedLocationList = LocationList()
}
