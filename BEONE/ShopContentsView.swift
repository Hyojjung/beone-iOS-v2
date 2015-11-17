//
//  ShopContentsView.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 17..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

class ShopContentsView: TemplateContentsView {
  @IBOutlet weak var imageView: LazyLoadingImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var productCountLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  func configureView(shop: Shop?) {
    if let shop = shop {
      imageView.setLazyLoaingImage(shop.backgroundImageUrl)
      nameLabel.text = shop.name
      descriptionLabel.text = shop.summary
      
      // TODO: Product Count
    }
  }
}
