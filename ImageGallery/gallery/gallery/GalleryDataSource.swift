import Foundation
import UIKit

class GalleryDataSource: NSObject, UICollectionViewDataSource {
    private let model: GalleryModel
    var title:String {
        get {
            return model.title
        }
    }

    init(_ title: String) {
        self.model = GalleryModel(title: title)
        super.init()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.loadImage(model.urls[indexPath.item])
        return cell
    }

    func get(_ index: Int) -> (URL, Float) {
        let url = model.urls[index]
        let ration = model.ratios[index]
        return (url,ration)
    }

    func insert(_ url: (URL, Float), index: Int) {
        model.ratios.insert(url.1, at: index)
        model.urls.insert(url.0, at: index)
    }

    func getRatio(_ index: Int) -> Float {
        return model.ratios[index]
    }

    func remove(_ index: Int?) {
        model.urls.remove(at: index!)
        model.ratios.remove(at: index!)
    }

}
