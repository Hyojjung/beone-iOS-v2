
extension Array {
  
  mutating func removeObject<U: Equatable>(object: U?) {
    var index: Int?
    for (idx, objectToCompare) in enumerate() {
      if let to = objectToCompare as? U {
        if object == to {
          index = idx
        }
      }
    }
    
    if let index = index {
      self.removeAtIndex(index)
    }
  }
  
  mutating func appendObject(element: Element?) {
    if let element = element {
      append(element)
    }
  }
  
  func hasEqualObjects<U: Equatable>(objects: [U]) -> Bool {
    if self.count == objects.count {
      for objectToCompare in self {
        for (index, object) in objects.enumerate() {
          if let objectToCompare = objectToCompare as? U {
            if object == objectToCompare {
              break
            }
          }
          if index == objects.count - 1 {
            return false
          }
        }
      }
      return true
    }
    return false
  }
  
  func objectAtIndex(index: Int?) -> Element? {
    if isInRange(index) {
      return self[index!]
    }
    return nil
  }
  
  func isInRange(index: Int?) -> Bool {
    if let index = index {
      return index < count
    }
    return false
  }
}

extension String {
  
  func convertToBigCamelCase() -> String {
    var bigCamelCaseString = String()
    if characters.count > 0 {
      bigCamelCaseString += String(characters.first! as Character).uppercaseString
      bigCamelCaseString += substringWithRange(Range(startIndex.advancedBy(1)..<endIndex))
    }
    return bigCamelCaseString
  }
}

extension UIColor {
  
  func imageWithColor() -> UIImage {
    let rect = CGRectMake(0, 0, 1, 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSetFillColorWithColor(context, CGColor)
    CGContextFillRect(context, rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
}