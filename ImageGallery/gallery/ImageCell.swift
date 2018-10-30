import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!//TODO remove
    @IBOutlet weak var image: UIImageView!
    private var url: URL? = nil

    func loadImage(_ url: URL) {
        if (url != self.url) {
            setNil()
        }
        self.url = url
        let closure: (Data?, URLResponse?, Error?) -> () = { (data, response, error) in
            if (error != nil) {
                self.setNil()
                return
            }
            if (response?.url != self.url) {
                self.setNil()
                return
            }
            DispatchQueue.main.async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        self.image.image = downloadedImage
                    }
                }
            }
        }
        URLSession.shared.dataTask(with: url, completionHandler: closure).resume()
    }

    private func setNil() {
        DispatchQueue.main.async {
            self.image.image = nil
        }
    }
}
