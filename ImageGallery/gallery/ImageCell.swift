//
// Created by Maurizio Pietrantuono on 23/10/2018.
// Copyright (c) 2018 Maurizio Pietrantuono. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var image: UIImageView!
    private var url: URL? = nil

    func loadImage(_ url: URL) {
        self.url = url
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlContents = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                if let imageData = urlContents, url == self?.url {
                    self?.image.image = UIImage(data: imageData)
                }
            }
        }

    }
}
