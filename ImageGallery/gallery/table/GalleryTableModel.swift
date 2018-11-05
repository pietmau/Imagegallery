import Foundation

class GalleryTableModel {
    let numberOfSections = 2
    var data: [[GalleryDataSource]] = [[], []]

    func addItem() {
        data[0].append(GalleryDataSource("Hello".madeUnique(withRespectTo: data.titles)))
    }

    func getTitle(at index: IndexPath) -> String? {
        return getDataSource(at: index).title
    }

    func getDataSource(at index: IndexPath) -> GalleryDataSource {
        return data[index.section][index.row]
    }

    func createFirstDataSource() {
        data.append([])
        data.append([])
        data[0].append(GalleryDataSource("Empty"))
    }

    func move(from: IndexPath, toSection: Int) -> IndexPath {
        let row = remove(from: from)
        return append(toSection: toSection, row: row)
    }

    func remove(from: IndexPath) -> GalleryDataSource {
        return data[from.section].remove(at: from.row)
    }

    func append(toSection: Int, row: GalleryDataSource) -> IndexPath {
        let rowsCount = data[toSection].count
        data[toSection].append(row)
        return IndexPath(row: rowsCount, section: toSection)
    }


    func numberOfRowsInSection(_ section: Int) -> Int {
        if (data.count > section) {
            return data[section].count
        } else {
            return 0
        }
    }

    func delete(at index: IndexPath) {
        data[index.section].remove(at: index.row)
    }
}


extension Array where Element == Array<GalleryDataSource> {

    var titles: Array<String> {
        get {
            return self.flatMap { list in
                list
            }.map { datum in
                datum.title
            }
        }
    }
}
