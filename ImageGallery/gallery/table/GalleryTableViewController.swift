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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        cell.textLabel?.text = model.getTitle(at: indexPath.item)
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


/*
// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

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

