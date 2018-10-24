//
// Created by Maurizio Pietrantuono on 24/10/2018.
// Copyright (c) 2018 Maurizio Pietrantuono. All rights reserved.
//

import Foundation
import UIKit

class GalleryDataSource: NSObject, UICollectionViewDataSource {
    private var urls: [(URL, Float)] = []

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.loadImage(urls[indexPath.item].0)
        return cell
    }

    func insert(_ url: (URL, Float), index: Int) {
        urls.insert(url, at: index)
    }

    func getRatio(_ index: Int) -> Float {
        return urls[index].1
    }
}
