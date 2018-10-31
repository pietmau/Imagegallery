import Foundation
import UIKit

class GalleryDataSource: NSObject, UICollectionViewDataSource {
    private var urls: [(URL, Float)] = []
    let title: String

    init(_ title: String) {
        self.title = title
        super.init()
    }

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

    func get(_ index: Int) -> (URL, Float) {
        return urls[index]
    }

    func insert(_ url: (URL, Float), index: Int) {
        urls.insert(url, at: index)
    }

    func getRatio(_ index: Int) -> Float {
        return urls[index].1
    }

    func remove(_ index: Int?) {
        urls.remove(at: index!)
    }

}