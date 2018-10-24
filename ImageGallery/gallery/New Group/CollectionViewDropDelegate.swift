import Foundation
import UIKit

class CollectionViewDropDelegate: NSObject, UICollectionViewDropDelegate {
    private let dataSource: GalleryDataSource
    private let sizeCalculator = SizeCalculator(5, 5)

    init(_ dataSource: GalleryDataSource) {
        self.dataSource = dataSource
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if (session.localDragSession?.localContext as? UICollectionView) == collectionView {
            return true
        }
        return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if (session.localDragSession?.localContext as? UICollectionView) == collectionView {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destination = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                onLocalDrop(destination: destination, item: item, collectionView: collectionView)
            } else {
                onNonLocalDrop(destination: destination, coordinator: coordinator, item: item)
            }
        }
    }

    private func onLocalDrop(destination: IndexPath, item: UICollectionViewDropItem, collectionView: UICollectionView) {
        if let url = item.dragItem.localObject as? (URL, Float) {
            collectionView.performBatchUpdates({
                dataSource.remove(item.sourceIndexPath?.item)
                dataSource.insert(url, index: destination.item)
                collectionView.deleteItems(at: [item.sourceIndexPath!])
                collectionView.insertItems(at: [destination])
            })
        }
    }

    private func onNonLocalDrop(destination: IndexPath, coordinator: UICollectionViewDropCoordinator, item: UICollectionViewDropItem) {
        let placeHolder = UICollectionViewDropPlaceholder(insertionIndexPath: destination, reuseIdentifier: "DropPlaceholderCell")
        let placeholderContext = coordinator.drop(item.dragItem, to: placeHolder)
        var url: URL? = nil
        var image: UIImage? = nil
        item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
            url = provider as? URL
            self.onObjectLoaded(url, image, placeholderContext)
            if (url == nil) {
                self.deletePlaceHolder(placeholderContext: placeholderContext)
            }
        }
        item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
            image = provider as? UIImage
            self.onObjectLoaded(url, image, placeholderContext)
            if (image == nil) {
                self.deletePlaceHolder(placeholderContext: placeholderContext)
            }
        }
    }

    private func deletePlaceHolder(placeholderContext: UICollectionViewDropPlaceholderContext) {
        DispatchQueue.main.async {
            placeholderContext.deletePlaceholder()
        }
    }

    private func onObjectLoaded(_ url: URL?, _ image: UIImage?, _ context: UICollectionViewDropPlaceholderContext) {
        if (url == nil || image == nil) {
            return
        }
        DispatchQueue.main.async {
            context.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                self.dataSource.insert((url!.imageURL, self.sizeCalculator.calculateRatio(image!)), index: insertionIndexPath.item)
            })
        }
    }
}
