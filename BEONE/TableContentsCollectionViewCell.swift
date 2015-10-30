//
//  TableContentsCollectionViewCell.swift
//  BEONE
//
//  Created by 효정 김 on 2015. 10. 30..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class TableContentsCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var backgroundImageView: LazyLoadingImageView!
  @IBOutlet weak var textLabel: UILabel!
  
  func configure(contents: Contents) {
    backgroundImageView.setLazyLoaingImage(contents.backgroundImageUrl)
    textLabel.textColor = contents.textColor
    textLabel.text = contents.text
    if let fontSize = contents.size {
      textLabel.font = UIFont.systemFontOfSize(fontSize)
    }
  }
}
