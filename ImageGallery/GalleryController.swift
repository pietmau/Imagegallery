//
// Created by Maurizio Pietrantuono on 17/04/2018.
// Copyright (c) 2018 Maurizio Pietrantuono. All rights reserved.
//

import Foundation
import UIKit

class GalleryController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    
    private var urls: [URL: CGSize] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        collectionView?.dragInteractionEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destination = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            let placeHolder =  UICollectionViewDropPlaceholder(insertionIndexPath: destination, reuseIdentifier:"DropPlaceholderCell")
            let placeholderContext = coordinator.drop(item.dragItem, to: placeHolder)
            item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
                guard let url = provider as? URL else {
                    placeholderContext.deletePlaceholder()
                    return}
            }
            item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                guard let image = provider as? UIImage else {
                    placeholderContext.deletePlaceholder()
                    return}
                DispatchQueue.main.async {
                    
                    //placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                        //self.urls[url] = image.size
                   // })
                }
            }
            
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
