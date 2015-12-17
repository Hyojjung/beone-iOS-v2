//
//  DynamicHeightTableView.swift
//  BOFlorist
//
//  Created by 효정 김 on 2015. 8. 27..
//  Copyright (c) 2015년 효정 김. All rights reserved.
//

import UIKit

protocol DynamicHeightTableViewProtocol: NSObjectProtocol {
  var dynamicHeightTableViewCells: [String: UITableViewCell] { get set }
  
  func configure(cell: UITableViewCell, indexPath: NSIndexPath)
  func cellIdentifier(indexPath: NSIndexPath) -> String
}

class DynamicHeightTableView: UITableView {
  weak var dynamicHeightDelgate: DynamicHeightTableViewProtocol!
  
  // MARK: - UITableViewDynamicHeightHelper
  
  func heightForBasicCell(indexPath: NSIndexPath) -> CGFloat {
    let cellIdentifier = dynamicHeightDelgate.cellIdentifier(indexPath)
    var cell = dynamicHeightDelgate.dynamicHeightTableViewCells[cellIdentifier]
    if cell == nil {
      cell = dequeueReusableCellWithIdentifier(cellIdentifier)
      dynamicHeightDelgate.dynamicHeightTableViewCells[cellIdentifier] = cell
    }
    if let cell = cell {
      dynamicHeightDelgate.configure(cell, indexPath: indexPath)
      return calculateHeight(cell)
    }
    return 0
  }
  
  private func calculateHeight(cell: UITableViewCell) -> CGFloat {
    cell.setNeedsDisplay()
    cell.layoutIfNeeded()
    let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    return size.height
  }
}
