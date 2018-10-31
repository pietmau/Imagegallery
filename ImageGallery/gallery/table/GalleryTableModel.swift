import Foundation

class GalleryTableModel {
    private var data: [GalleryDataSource] = []
    private var deleted: [GalleryDataSource] = []

    var count: Int {
        get {
            return data.count
        }
    }

    func addItem() {
        var titles = data.titles
        titles.append(contentsOf: deleted.titles)
        data.append(GalleryDataSource("Hello".madeUnique(withRespectTo: titles)))
    }

    func getTitle(at index: IndexPath) -> String? {
        if (index.section == 0) {
            return data[index.row].title
        } else {
            return deleted[index.row].title
        }
    }

    func getDataSource(at index: Int) -> GalleryDataSource {
        if (data.count <= 0) {
            addItem()
        }
        return data[index]
    }

    func moveRowToDeleted(at: Int) -> Int {
        let row = data.remove(at: at)
        let size = deleted.count
        deleted.append(row)
        return size
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        switch section {
        case 1: return deleted.count
        default: return data.count
        }
    }

    func delete(at index: Int) {
        deleted.remove(at: index)
    }
}


extension Array where Element == GalleryDataSource {

    var titles: Array<String> {
        get {
            return self.map { (datum) in
                datum.title
            }
        }
    }
}
