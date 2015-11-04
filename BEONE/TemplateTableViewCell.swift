//
//  TemplateTableViewCell.swift
//  BEONE
//
//  Created by 김 효정 on 2015. 11. 1..
//  Copyright © 2015년 효정 김. All rights reserved.
//

import UIKit

let kNibNameTemplateTableViewCell = "TemplateTableViewCell"
let kCellIdentifierTemplateTableViewCell = "templateTableViewCell"

class TemplateTableViewCell: UITableViewCell {
  @IBOutlet weak var templateView: TemplateView!
  
  func configureCell(template: Template) {
    templateView.layoutView(template)
  }
}
