//
//  MainTitleView.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 26..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class MainTitleView: UIView {
  @IBOutlet weak var locationLabel: UILabel!

  @IBAction func locationButtonTapped(sender: AnyObject) {
    postNotification(kNotificationLocationButtonTapped)
  }
}
