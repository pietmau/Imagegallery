import Foundation
import UIKit

class CollectionViewDragDelegate: NSObject, UICollectionViewDragDelegate {
    private let source: GalleryDataSource

    init(_ source: GalleryDataSource) {
        self.source = source
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let url = source.get(indexPath.item)
        session.localContext = collectionView
        let provider = NSItemProvider(contentsOf: url.0)
        if (provider != nil) {
            let item = UIDragItem(itemProvider: provider!)
            item.localObject = url
            return [item]
        }
        return []
    }

}
