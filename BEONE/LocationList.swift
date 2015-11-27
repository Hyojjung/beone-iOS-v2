//
//  LocationList.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class LocationList: BaseListModel {
  override func fetchUrl() -> String {
    return "locations"
  }
  
  override func assignObject(data: AnyObject) {
    if let locationList = data[kNetworkResponseKeyData] as? [[String: AnyObject]] {
      list.removeAll()
      for locationObject in locationList {
        let location = Location()
        location.assignObject(locationObject)
        list.append(location)
      }
      // TODO: - default?
      BEONEManager.selectedLocation = list.first as? Location
      postNotification(kNotificationFetchLocationListSuccess)
    }
  }
  
  func locationNames() -> [String] {
    var names = [String]()
    print(self)
    for location in list as! [Location] {
      if let locationName = location.name {
        names.append(locationName)
      }
    }
    return names
  }
}
