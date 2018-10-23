//
// Created by Maurizio Pietrantuono on 17/04/2018.
// Copyright (c) 2018 Maurizio Pietrantuono. All rights reserved.
//

import Foundation
import UIKit

class GalleryController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    private var urls: [(URL, Float)] = []
    private let sizeCalculator = SizeCalculator(5,6)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        collectionView?.dragInteractionEnabled = true
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destination = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        onNonLocalDrag(coordinator, destination)
    }

    private func onNonLocalDrag(_ coordinator: UICollectionViewDropCoordinator, _ destination: IndexPath) {
        for item in coordinator.items {
            let placeHolder = UICollectionViewDropPlaceholder(insertionIndexPath: destination, reuseIdentifier: "DropPlaceholderCell")
            let placeholderContext = coordinator.drop(item.dragItem, to: placeHolder)
            var url: URL? = nil
            var image: UIImage? = nil
            item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
                url = provider as? URL
                self.onObjectLoaded(url, image, placeholderContext)
                if (url == nil) {
                    placeholderContext.deletePlaceholder()
                }
            }
            item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                image = provider as? UIImage
                self.onObjectLoaded(url, image, placeholderContext)
                if (image == nil) {
                    placeholderContext.deletePlaceholder()
                }
            }
        }
    }

    private func onObjectLoaded(_ url: URL?, _ image: UIImage?, _ context: UICollectionViewDropPlaceholderContext) {
        if (url == nil || image == nil) {
            return
        }
        context.commitInsertion(dataSourceUpdates: { insertionIndexPath in
            self.urls.insert((url!, sizeCalculator.calculateRatio(image!)), at: insertionIndexPath.item)
        })
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let ratio: Float = urls[indexPath.item].1
        let size = sizeCalculator.getSize(ratio, UIDevice.current.orientation, UIScreen.main.bounds)
        return ratio
    }

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return []
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ImageCell", for: indexPath)
        return cell
    }
}
