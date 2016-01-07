
extension Array {
  mutating func removeObject<U: Equatable>(object: U) {
    var index: Int?
    for (idx, objectToCompare) in self.enumerate() {
      if let to = objectToCompare as? U {
        if object == to {
          index = idx
        }
      }
    }
    
    if(index != nil) {
      self.removeAtIndex(index!)
    }
  }
}

extension String {
  func convertToBigCamelCase() -> String {
    var bigCamelCaseString = String()
    if characters.count > 0 {
      bigCamelCaseString += String(characters.first! as Character).uppercaseString
      bigCamelCaseString += substringWithRange(Range<String.Index>(start: startIndex.advancedBy(1), end: endIndex))
    }
    return bigCamelCaseString
  }
}

extension UITableView {
//  func cell(cellIdentifier: String, indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = dequeueReusableCellWithIdentifier(cellIdentifier)
//    if let cell = cell {
//      return cell
//    } else {
//      registerNib(UINib(nibName: cellIdentifier.convertToBigCamelCase(), bundle: nil), forCellReuseIdentifier: cellIdentifier)
//      return dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
//    }
//  }
}
