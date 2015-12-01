
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

let kCellNibNameDictionary = [kDeliveryTypeCellIdentifier: "DeliveryTypeImageCell",
  kShopNameCellIdentifier: "ShopNameCell"]

extension UITableView {
  func cell(cellIdentifier: String, indexPath: NSIndexPath) -> UITableViewCell {
    let cell = dequeueReusableCellWithIdentifier(cellIdentifier)
    if let cell = cell {
      return cell
    } else {
      registerNib(UINib(nibName: kCellNibNameDictionary[cellIdentifier]!, bundle: nil), forCellReuseIdentifier: cellIdentifier)
      return dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
    }
  }
}
