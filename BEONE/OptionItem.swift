
import UIKit

enum OptionItemType: String {
  case Text = "text"
  case Select = "select"
  case String = "string"
}

class OptionItem: BaseModel {
  var name: String?
  var type = OptionItemType.Select
  var value: String?
  var selectedName: String?
  
  var placeholder: String?
  var minLength: Int?
  var maxLength: Int?
  var isRequired = false
  // for string, text type
  var selects = [Select]()
  // for select type
  
  override func assignObject(data: AnyObject?) {
    if let optionItemObject = data as? [String: AnyObject] {
      if let originalId = optionItemObject["originalId"] as? Int {
        id = originalId
      } else {
        id = optionItemObject[kObjectPropertyKeyId] as? Int
      }
      name = optionItemObject[kObjectPropertyKeyName] as? String
      if let typeString = optionItemObject["type"] as? String, type = OptionItemType(rawValue: typeString) {
        self.type = type
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
          selects.appendObject(select)
          if select.name == value {
            selectedName = select.selectName()
          }
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
    optionItem.selectedName = selectedName?.copy() as? String
    optionItem.maxLength = maxLength
    optionItem.minLength = minLength
    optionItem.isRequired = isRequired
    
    for select in selects {
      let copiedSelect = select.copy()
      optionItem.selects.appendObject(copiedSelect as! Select)
    }
    return optionItem
  }
  
  func validationMessage() -> String? {
    if let name = name {
      if value == nil {
        if type == .Select {
          return "\(name)" + NSLocalizedString("select", comment: "error message")
        } else {
          return "\(name)" + NSLocalizedString("insert", comment: "error message")
        }
      }
      if type != .Select {
        if let minLength = minLength {
          if value?.characters.count < minLength {
            return "\(name)" + NSLocalizedString("length", comment: "error message")
              + "\(minLength)" + NSLocalizedString("more than", comment: "error message")
          }
        }
        if let maxLength = maxLength {
          if value?.characters.count > maxLength {
            return "\(name)" + NSLocalizedString("length", comment: "error message")
              + "\(maxLength)" + NSLocalizedString("less than", comment: "error message")
          }
        }
      }
    }
    return nil
  }

  func serverFormat() -> [String: AnyObject] {
    var serverFormat = [String: AnyObject]()
    serverFormat["originalId"] = id
    serverFormat["value"] = value
    return serverFormat
  }
}