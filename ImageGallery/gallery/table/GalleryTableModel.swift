import Foundation

class GalleryTableModel {
    private var data: [GalleryData] = []

    var count: Int {
        get {
            return data.count
        }
    }

    func addItem() {
        let strings = data.map { (datum) in
            datum.title
        }
        data.append(GalleryData("Hello".madeUnique(withRespectTo: strings)))
    }

    class GalleryData {
        private var data: [(URL, Float)] = []
        var title: String = ""

        init(_ title: String) {
            self.title = title
        }
    }
}
