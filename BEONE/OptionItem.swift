
import UIKit

enum OptionItemType: String {
  case Text = "text"
  case Select = "select"
  case String = "string"
}

class OptionItem: BaseModel {
  var name: String?
  var type: OptionItemType?
  var value: String?
  
  var placeholder: String?
  var minLength: Int?
  var maxLength: Int?
  var isRequired = false
  // for string, text type
  var selects = [Select]()
  // for select type
  
  override func assignObject(data: AnyObject) {
    if let optionItemObject = data as? [String: AnyObject] {
      id = optionItemObject[kObjectPropertyKeyId] as? Int
      name = optionItemObject["name"] as? String
      if let type = optionItemObject["type"] as? String {
        self.type = OptionItemType(rawValue: type)
      }
      value = optionItemObject["value"] as? String
      
      placeholder = optionItemObject["placeholder"] as? String
      minLength = optionItemObject["minLength"] as? Int
      maxLength = optionItemObject["maxLength"] as? Int
      if let isRequired = optionItemObject["isRequired"] as? Bool {
        self.isRequired = isRequired
      }
      
      if let selectObjects = optionItemObject["selects"] as? [[String: AnyObject]] {
        for selectObject in selectObjects {
          let select = Select()
          select.assignObject(selectObject)
          selects.append(select)
        }
      }
    }
  }
  
  override func copy() -> AnyObject {
    let optionItem = OptionItem()
    optionItem.id = id
    optionItem.name = name?.copy() as? String
    optionItem.type = type
    optionItem.value = value?.copy() as? String
    optionItem.placeholder = placeholder?.copy() as? String
    optionItem.maxLength = maxLength
    optionItem.minLength = minLength
    optionItem.isRequired = isRequired
    
    for select in selects {
      let copiedSelect = select.copy()
      optionItem.selects.append(copiedSelect as! Select)
    }
    return optionItem
  }
  
  func isValid() -> Bool {
    if value == nil {
      return false
    }
    if type != .Select {
      if let minLength = minLength {
        if value?.characters.count < minLength {
          return false
        }
      }
      if let maxLength = maxLength {
        if value?.characters.count > maxLength {
          return false
        }
      }
    }
    return true
  }

  func serverFormat() -> [String: AnyObject] {
    var serverFormat = [String: AnyObject]()
    serverFormat["originalId"] = id
    serverFormat["value"] = value
    return serverFormat
  }
}