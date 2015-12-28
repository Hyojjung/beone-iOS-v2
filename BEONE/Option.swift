
import UIKit

class Option: BaseModel {
  
  var name: String?
  var isSelected = false
  var price = 0
  var isSoldOut = false
  var optionItems = [OptionItem]()
  
  override func assignObject(data: AnyObject) {
    if let optionObject = data as? [String: AnyObject] {
      id = optionObject[kObjectPropertyKeyId] as? Int
      name = optionObject["name"] as? String
      
      if let actualPrice = optionObject["actualPrice"] as? Int {
        price = actualPrice
      }
      if let isSelected = optionObject["isSelected"] as? Bool {
        self.isSelected = isSelected
      }
      if let isSoldOut = optionObject["isSoldOut"] as? Bool {
        self.isSoldOut = isSoldOut
      }
      
      if let optionObjects = optionObject["optionItems"] as? [[String: AnyObject]] {
        optionItems.removeAll()
        for optionItemObject in optionObjects {
          let optionItem = OptionItem()
          optionItem.assignObject(optionItemObject)
          optionItems.append(optionItem)
        }
      }
    }
  }
  
  override func copy() -> AnyObject {
    let option = Option()
    option.id = id
    option.isSelected = isSelected
    option.price = price
    option.isSoldOut = isSoldOut
    option.name = name?.copy() as? String
    for optionItem in optionItems {
      let copiedOptionItem = optionItem.copy()
      option.optionItems.append(copiedOptionItem as! OptionItem)
    }
    return option
  }
}
