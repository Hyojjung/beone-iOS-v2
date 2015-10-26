//
//  MyInfo+CoreDataProperties.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyInfo {
    @NSManaged var accessToken: String?
    @NSManaged var authenticationId: NSNumber?
    @NSManaged var deviceToken: String?
    @NSManaged var refreshToken: String?
    @NSManaged var userDeviceInfoId: NSNumber?
    @NSManaged var userId: NSNumber?

}
