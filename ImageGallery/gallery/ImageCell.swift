import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!//TODO remove
    @IBOutlet weak var image: UIImageView!
    private var task: Task?

    func loadImage(_ url: URL) {
        if (url != task?.url) {
            task?.cancel()
            task = nil
        }
        task = Task(image, url)
    }

    class Task {
        var image: UIImageView?
        var url: URL? = nil
        var urlSessionDataTask: URLSessionDataTask? = nil

        init(_ image: UIImageView, _ url: URL) {
            self.image = image
            self.url = url
            setNil()
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
                            self.image?.image = downloadedImage
                        }
                    }
                }
            }
            urlSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: closure)
            urlSessionDataTask?.resume()
        }

        private func setNil() {
            DispatchQueue.main.async {
                self.image?.image = nil
            }
        }

        func cancel() {
            setNil()
            urlSessionDataTask?.cancel()
            self.image = nil
        }
    }


}
