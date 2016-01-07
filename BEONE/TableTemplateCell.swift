
import UIKit

let kSpaceWidthCell = CGFloat(10)
let kNoSpaceWidthCell = CGFloat(0)
let kTableContentsCollectionViewCellNibName = "TableContentsCollectionViewCell"
let kTableContentsCellIdentifier = "tableContentsCell"

class TableTemplateCell: TemplateCell {
  @IBOutlet weak var collectionView: UICollectionView!
  private var content: Content?
  private var column: Int?
  private var row: Int?
  private var hasSpace: Bool?
  
  private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    self.collectionView.collectionViewLayout = layout
    return layout
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.registerNib(UINib(nibName: kTableContentsCollectionViewCellNibName, bundle: nil),
      forCellWithReuseIdentifier: kTableContentsCellIdentifier)
  }
  
  override func configureCell(template: Template, forCalculateHeight: Bool) {
    super.configureCell(template, forCalculateHeight: forCalculateHeight)
    if !forCalculateHeight {
      templateId = template.id
      content = template.content
    }
    hasSpace = template.content.hasSpace
    row = template.content.row
    column = template.content.column
    setUpCollectionViewFlowLayout(collectionViewLayout, forCalculateHeight: forCalculateHeight)
    collectionView.reloadData()
  }
  
  private func setUpCollectionViewFlowLayout(collectionViewLayout: UICollectionViewFlowLayout, forCalculateHeight: Bool) {
    let space = self.hasSpace != nil && self.hasSpace! ? kSpaceWidthCell : kNoSpaceWidthCell
    if !forCalculateHeight {
      collectionViewLayout.minimumInteritemSpacing = space
      collectionViewLayout.minimumLineSpacing = space
    }
    
    if let column = self.column, row = self.row {
      let itemWidth = (frame.width - space * CGFloat(column - 1)) / CGFloat(column)
      if !forCalculateHeight {
        collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
      }
      let height = itemWidth * CGFloat(row) + space * CGFloat(row - 1)
      layoutContentsView(templateId, height: height, contentsView: collectionView)
    }
  }
  
}

// MARK: - UICollectionViewDataSource

extension TableTemplateCell {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return content?.items.count != nil ? content!.items.count : 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kTableContentsCellIdentifier,
      forIndexPath: indexPath) as! TableContentsCollectionViewCell
    if content != nil && content?.items.count > indexPath.row {
      cell.configure(content!.items[indexPath.row])
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension TableTemplateCell: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    if let templateId = templateId, content = content, contentsId = content.id {
      postNotification(kNotificationDoAction,
        userInfo: [kNotificationKeyTemplateId: templateId, kNotificationKeyContentsId: contentsId])
    }
  }
}