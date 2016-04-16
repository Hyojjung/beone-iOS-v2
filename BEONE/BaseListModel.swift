
import UIKit

let kDefaultCountPerPage = 20

class BaseListModel: BaseModel {
  var count: Int?
  var total = 0
  var page: Int?
  var list = [BaseModel]()
  
  override func get(getSuccess: (() -> Void)? = nil) {
    print("BASELISTMODEL \(getUrl())")
    NetworkHelper.requestGet(getUrl(), parameter: getParameter(), success: { (result) -> Void in
      if let result = result as? [String: AnyObject] {
        if let total = result["total"] as? Int {
          self.total = total
        }
        self.assignObject(result[kNetworkResponseKeyData])
      }
      getSuccess?()
      }, failure: nil)
  }
  
  func needFetch(index: Int) -> Bool {
    if let count = count {
      if count < total && index / kDefaultCountPerPage == 0 && count == index {
        return true
      }
    }
    return false
  }
  
  func model(id: Int?) -> BaseModel? {
    for model in list {
      if model.id == id {
        return model
      }
    }
    return nil
  }
}