//
//  NetworkError.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

enum NetworkResponseCode: Int {
    case None
    case Success = 200
    case Invalid = 400
    case NeedAuthority
    case Forbidden = 403
    case NotFound
    case NotAllowed
    case Duplicated = 409
    case LogInTokenExpired
    case CannotGoThrough = 422
    case SomethingWrongInServer = 500
    case BadGateWay = 502
    case ServiceUnavailable = 503
}

struct NetworkError {
    
    var statusCode : Int?
    var originalErrorCode : Int?
    var responseObject : AnyObject?
    
    // MARK: - Init & Dealloc Methods
    
    init (statusCode: NSInteger?, originalErrorCode: NSInteger?, responseObject: AnyObject?) {
        self.statusCode = statusCode
        self.originalErrorCode = originalErrorCode
        self.responseObject = responseObject
    }
}
