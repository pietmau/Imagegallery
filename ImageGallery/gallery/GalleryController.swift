import Foundation
import UIKit

class GalleryController: UIViewController, UICollectionViewDelegateFlowLayout {
    private let dataSource = GalleryDataSource()
    private let sizeCalculator = SizeCalculator(5, 5)
    private var dropDelegate: CollectionViewDropDelegate? = nil
    private var dragDelegate: CollectionViewDragDelegate? = nil

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            dragDelegate = CollectionViewDragDelegate(dataSource)
            collectionView.dragDelegate = dragDelegate!
            dropDelegate = CollectionViewDropDelegate(dataSource)
            collectionView.dropDelegate = dropDelegate!
            collectionView.dragInteractionEnabled = true
            collectionView.delegate = self
            collectionView.dataSource = dataSource
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: Float = dataSource.getRatio(indexPath.item)
        let cgSize = sizeCalculator.getSize(ratio, UIDevice.current.orientation, self.view.window?.frame)
        return cgSize
    }
}
