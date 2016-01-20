
import UIKit

let kDefaultCountPerPage = 20

class BaseListModel: BaseModel {
  var count: Int?
  var total = 0
  var page: Int?
  var list = [BaseModel]()
  
  func needFetch(index: Int) -> Bool {
    if let count = count {
      if count < total && index / kDefaultCountPerPage == 0 && count == index {
        return true
      }
    }
    return false
  }
}

