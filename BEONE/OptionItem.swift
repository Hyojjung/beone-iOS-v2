
import UIKit

enum OptionType: String {
  case Text = "text"
  case Select = "select"
  case String = "string"
}

class OptionItem: BaseModel {
  var name: String?
  var optionType: OptionType?
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
      if let optionType = optionItemObject["type"] as? String {
        self.optionType = OptionType(rawValue: optionType)
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
}