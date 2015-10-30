//
//  NetworkStringFormatter.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 29..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

extension String {
  private func isUrlString() -> Bool {
    return rangeOfString("://") != nil
  }
  
  func trimedString() -> String {
    return stringByReplacingOccurrencesOfString(" ", withString: "")
  }
  
  private func urlForm() -> String {
    return !isUrlString() ? kBaseUrl.stringByAppendingString(self) : self;
  }
  
  func url() -> NSURL {
    return NSURL(string: trimedString().urlForm())!
  }
}