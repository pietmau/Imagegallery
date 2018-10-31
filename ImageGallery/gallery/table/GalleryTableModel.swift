import Foundation

class GalleryTableModel {
    private var data: [GalleryDataSource] = []

    var count: Int {
        get {
            return data.count
        }
    }

    func addItem() {
        let strings = data.map { (datum) in
            datum.title
        }
        data.append(GalleryDataSource("Hello".madeUnique(withRespectTo: strings)))
    }

    func getTitle(at index: Int) -> String? {
        return data[index].title
    }

    func getDataSource(at index: Int) -> GalleryDataSource {
        if(data.count<=0){
            addItem()
        }
        return data[index]
    }
}
