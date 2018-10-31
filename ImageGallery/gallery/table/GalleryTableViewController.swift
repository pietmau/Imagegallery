import UIKit

class GalleryTableViewController: UITableViewController {
    private let model = GalleryTableModel()

    @IBAction func onAddClicked(_ sender: UIBarButtonItem) {
        model.addItem()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewControllers = (navigationController?.parent as? UISplitViewController)?.viewControllers
        if (viewControllers!.count > 1) {
            if let navController = (viewControllers![1] as? UINavigationController),
               let gallery = navController.contents as? GalleryController {
                gallery.dataSource = getDatasource(at: 0)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfRowsInSection(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        cell.textLabel?.text = model.getTitle(at: indexPath)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
           identifier == "MyDetailSegue",
           let cell = sender as? UITableViewCell,
           let index = tableView.indexPath(for: cell),
           let navigationController = segue.destination as? UINavigationController,
           let galleryController = navigationController.contents as? GalleryController {
            galleryController.dataSource = getDatasource(at: index.item)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (indexPath.section == 0) {
                moveRow(indexPath: indexPath, tableView: tableView)
            } else {
                deleteRow(indexPath: indexPath, tableView: tableView)
            }
        }
    }

    private func deleteRow(indexPath: IndexPath, tableView: UITableView) {
        tableView.performBatchUpdates({
            let newRow = model.delete(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
    }

    private func moveRow(indexPath: IndexPath, tableView: UITableView) {
        tableView.performBatchUpdates({
            let newRow = model.moveRowToDeleted(at: indexPath.item)
            let newPath = IndexPath(row: newRow, section: 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [newPath], with: .fade)
        })
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? UITableViewHeaderFooterView
        if (section == 0) {
            return nil
        }
        if (cell == nil) {
            cell = UITableViewHeaderFooterView(reuseIdentifier: "HeaderCell")
        }
        let view = UIView()
        view.backgroundColor = view.tintColor
        cell!.backgroundView = view
        cell?.textLabel?.text = "Deleted"
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return CGFloat(1)
        }
        return CGFloat(48)
    }

/*
// Override to support rearranging the table view.
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
}
*/

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}
*/

    private func getDatasource(at index: Int) -> GalleryDataSource {
        return model.getDataSource(at: index)
    }
}

