//
//  NetworkError.swift
//  BOFlorist
//
//  Created by 효정 김 on 2015. 8. 18..
//  Copyright (c) 2015년 효정 김. All rights reserved.
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
    
    var statusCode : NSInteger?
    var originalErrorCode : NSInteger?
    var responseObject : AnyObject?
    
    // MARK: - Init & Dealloc Methods
    
    init (statusCode: NSInteger?, originalErrorCode: NSInteger?, responseObject: AnyObject?) {
        self.statusCode = statusCode
        self.originalErrorCode = originalErrorCode
        self.responseObject = responseObject
    }
}
