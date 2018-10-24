//
// Created by Maurizio Pietrantuono on 24/10/2018.
// Copyright (c) 2018 Maurizio Pietrantuono. All rights reserved.
//

import Foundation
import UIKit

class GalleryFlowLayout: UICollectionViewDelegateFlowLayout {
    private let sizeCalculator = SizeCalculator(5, 5)
    private let dataSource: GalleryDataSource

    init(_ source: GalleryDataSource) {
        dataSource = source
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
        let ratio: Float = dataSource.getRatioAtIndexpath(indexPath.item)
        let cgSize = sizeCalculator.getSize(ratio, UIDevice.current.orientation, view.window?.frame)
        return cgSize
    }
}
