import Foundation
import UIKit

class GalleryController: UIViewController, UICollectionViewDelegateFlowLayout {
    private let sizeCalculator = SizeCalculator(5, 5)
    private var dropDelegate: CollectionViewDropDelegate? = nil
    private var dragDelegate: CollectionViewDragDelegate? = nil
    private var recognizer: UIPinchGestureRecognizer? = nil

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            if (dataSource != nil) {
                dragDelegate = CollectionViewDragDelegate(dataSource!)
                collectionView.dragDelegate = dragDelegate!
                dropDelegate = CollectionViewDropDelegate(dataSource!)
                collectionView.dropDelegate = dropDelegate!
                collectionView.dragInteractionEnabled = true
                collectionView.delegate = self
                collectionView.dataSource = dataSource
                let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                recognizer = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(recognizer:)))
                collectionView.addGestureRecognizer(recognizer!)
                collectionView.reloadData()
            }
        }
    }

    var dataSource: GalleryDataSource? = nil {
        didSet {
            if (collectionView != nil) {
                dragDelegate = CollectionViewDragDelegate(dataSource!)
                collectionView.dragDelegate = dragDelegate!
                dropDelegate = CollectionViewDropDelegate(dataSource!)
                collectionView.dropDelegate = dropDelegate!
                collectionView.dragInteractionEnabled = true
                collectionView.delegate = self
                collectionView.dataSource = dataSource
                let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
                recognizer = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(recognizer:)))
                collectionView.addGestureRecognizer(recognizer!)
                collectionView.reloadData()
            }
        }
    }

    @objc
    private func onPinch(recognizer: UIPinchGestureRecognizer) {
        sizeCalculator.onPinch(recognizer)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: Float = dataSource!.getRatio(indexPath.item)
        let cgSize = sizeCalculator.getSize(ratio, UIDevice.current.orientation, collectionView.frame)
        return cgSize
    }
}
