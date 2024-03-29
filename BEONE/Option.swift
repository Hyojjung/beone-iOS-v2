
import UIKit

class Option: BaseModel {
  
  var name: String?
  var isSelected = false
  var price = 0
  var isSoldOut = false
  var optionItems = [OptionItem]()
  
  override func assignObject(data: AnyObject?) {
    if let optionObject = data as? [String: AnyObject] {
      if let originalId = optionObject["originalId"] as? Int {
        id = originalId
      } else {
        id = optionObject[kObjectPropertyKeyId] as? Int
      }
      name = optionObject[kObjectPropertyKeyName] as? String
      
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
          optionItems.appendObject(optionItem)
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
      option.optionItems.appendObject(copiedOptionItem as? OptionItem)
    }
    return option
  }
  
  func optionName() -> String? {
    if price == 0 {
      return name
    } else if let name = name {
      return name + " (+ \(price.priceNotation(.Korean)))"
    }
    return nil
  }
  
  func validationMessage() -> String? {
    for optionItem in optionItems {
      if let validationMessage = optionItem.validationMessage() {
        return validationMessage
      }
    }
    return nil
  }
  
  func optionString() -> String {
    var optionString = String()
    optionString += "\(name!)"
    if price > 0 {
      optionString += " (+ \(price.priceNotation(.Korean)))"
    }
    for optionItem in optionItems {
      if let value = optionItem.value {
        optionString += " / \(value)"
      }
    }
    return optionString
  }
  
  func serverFormat() -> [String: AnyObject] {
    var serverFormat = [String: AnyObject]()
    serverFormat["originalId"] = id
    serverFormat["isSelected"] = isSelected
    if isSelected && optionItems.count > 0 {
      var optionItemsServerFormat = [[String: AnyObject]]()
      for optionItem in optionItems {
        optionItemsServerFormat.appendObject(optionItem.serverFormat())
      }
      serverFormat["optionItems"] = optionItemsServerFormat
    }
    return serverFormat
  }
}
