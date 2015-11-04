//
//  StringValidationHelper.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 27..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

extension String {
  func isValidEmail() -> Bool {
    do {
      let regularExpression = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}",
        options: .CaseInsensitive)
      return regularExpression.firstMatchInString(self,
        options: NSMatchingOptions(rawValue: 0),
        range: NSMakeRange(0, self.characters.count)) != nil
    } catch {
      return false
    }
  }
  
  func isValidPassword() -> Bool {
    do {
      let regularExpression = try NSRegularExpression(pattern: "(?!^[A-Za-z]+$)(?!^[0-9]+$)(?!^[\\`\\~\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\]\\{\\}\\;\\:\\\'\\\"\\,\\.\\<\\>\\/\\?]+$)^[A-Za-z0-9\\`\\~\\!\\@\\#\\$\\%\\^\\&\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\]\\{\\}\\;\\:\\\'\\\"\\,\\.\\<\\>\\/\\?]{8,20}$",
        options: .CaseInsensitive)
      return regularExpression.firstMatchInString(self,
        options: NSMatchingOptions(rawValue: 0),
        range: NSMakeRange(0, self.characters.count)) != nil
    } catch {
      return false
    }
  }
  
  func emailCharacterString() -> String {
    do {
      let regex = try NSRegularExpression(pattern: "[A-Z0-9.@]+", options: .CaseInsensitive)
      let nsString = self as NSString
      let results = regex.matchesInString(self, options: [], range: NSMakeRange(0, nsString.length))
      let strings = results.map {
        nsString.substringWithRange($0.range)
      }
      return strings.joinWithSeparator("")
    } catch {
      return String()
    }
  }
}