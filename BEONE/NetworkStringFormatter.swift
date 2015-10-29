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
  
  private func trimedString() -> String {
    return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
  
  private func urlForm() -> String {
    return !isUrlString() ? "https://devapi.beone.kr".stringByAppendingString(self) : self;
    // TODO: - Base Url 로 변경
  }
  
  func url() -> NSURL {
    return NSURL(string: trimedString().urlForm())!
  }
}