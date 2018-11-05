import Foundation

struct GalleryModel: Codable {
    var urls: [URL] = []
    var ratios: [Float] = []
    let title: String

    var count: Int {
        return urls.count
    }

    init(title: String) {
        self.title = title
    }

    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(GalleryModel.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }

    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
