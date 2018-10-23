//
// Created by Maurizio Pietrantuono on 17/04/2018.
// Copyright (c) 2018 Maurizio Pietrantuono. All rights reserved.
//

import Foundation
import UIKit

class GalleryController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate,
        UICollectionViewDelegateFlowLayout {
    private var urls: [(URL, Float)] = []
    private let sizeCalculator = SizeCalculator(5, 5)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.dragDelegate = self
        collectionView!.dropDelegate = self
        collectionView!.dragInteractionEnabled = true
        collectionView!.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destination = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                onLocalDrop(destination: destination, coordinator: coordinator, item: item)
            } else {
                onNonLocalDrop(destination: destination, coordinator: coordinator, item: item)
            }
        }
    }

    private func onLocalDrop(destination: IndexPath, coordinator: UICollectionViewDropCoordinator, item: UICollectionViewDropItem) {

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
                self.urls.insert((url!.imageURL, self.sizeCalculator.calculateRatio(image!)), at: insertionIndexPath.item)
            })
        }
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

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.loadImage(urls[indexPath.item].0)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }


    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: Float = urls[indexPath.item].1
        let cgSize = sizeCalculator.getSize(ratio, UIDevice.current.orientation, self.view.window?.frame)
        return cgSize
    }
}
