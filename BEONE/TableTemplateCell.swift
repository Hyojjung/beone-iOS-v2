
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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.registerNib(UINib(nibName: kTableContentsCollectionViewCellNibName, bundle: nil),
      forCellWithReuseIdentifier: kTableContentsCellIdentifier)
  }
  
  override func configureCell(template: Template) {
    super.configureCell(template)
    templateId = template.id
    content = template.content
    hasSpace = template.content.hasSpace
    row = template.content.row
    column = template.content.column
    setUpCollectionViewFlowLayout(template)
    collectionView.reloadData()
  }
  
  override func calculatedHeight(template: Template) -> CGFloat {
    if let height = template.height {
      return height
    } else {
      var height: CGFloat = 0
      height += template.verticalMargin()
      
      let space = template.content.hasSpace != nil && template.content.hasSpace! ?
        kSpaceWidthCell : kNoSpaceWidthCell
      if let column = template.content.column, row = template.content.row {
        let viewWidth = self.viewWidth(template)
        let itemWidth = (viewWidth - space * CGFloat(column - 1)) / CGFloat(column)
        
        height += itemWidth * CGFloat(row) + space * CGFloat(row - 1)
      }
      template.height = height
      return height
    }
  }
}

extension TableTemplateCell {

  private func setUpCollectionViewFlowLayout(template: Template) {
    if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      let space = self.hasSpace != nil && self.hasSpace! ? kSpaceWidthCell : kNoSpaceWidthCell
      collectionViewLayout.minimumInteritemSpacing = space
      collectionViewLayout.minimumLineSpacing = space
      
      if let column = self.column{
        let viewWidth = self.viewWidth(template)
        let itemWidth = (viewWidth - space * CGFloat(column - 1)) / CGFloat(column)
        collectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
      }
    }
  }
  
  private func viewWidth(template: Template) -> CGFloat {
    return ViewControllerHelper.screenWidth - template.horizontalMargin()
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
    cell.configure(content?.items.objectAtIndex(indexPath.row))
    return cell
  }
}