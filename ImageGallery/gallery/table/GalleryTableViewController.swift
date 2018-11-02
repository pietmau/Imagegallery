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
                let path = IndexPath(row: 0, section: 0)
                model.createFirstDataSource()
                gallery.dataSource = getDatasource(at: path)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfSections
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
            galleryController.dataSource = getDatasource(at: index)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if (indexPath.section == 0) {
                moveRow(from: indexPath, toSection: 1, tableView: tableView)
            } else if (indexPath.section == 1) {
                deleteRow(indexPath: indexPath, tableView: tableView)
            }
        }
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = createActions(indexPath)
        return UISwipeActionsConfiguration(actions: actions)
    }

    private func createActions(_ index: IndexPath) -> [UIContextualAction] {
        if (index.section == 1) {
            var action = UIContextualAction(style: .destructive, title: "Undelete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                self.undelete(at: index)
                completionHandler(true)
            }
            action.backgroundColor = UIColor.green
            let actions: [UIContextualAction] = [action]
            return actions
        } else {
            return []
        }
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

    private func deleteRow(indexPath: IndexPath, tableView: UITableView) {
        tableView.performBatchUpdates({
            model.delete(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
    }

    private func moveRow(from: IndexPath, toSection: Int, tableView: UITableView) {
        let row = model.remove(from: from)
        tableView.deleteRows(at: [from], with: .fade)
        let path = model.append(toSection: toSection, row: row)
        tableView.insertRows(at: [path], with: .fade)
    }

    private func getDatasource(at index: IndexPath) -> GalleryDataSource {
        return model.getDataSource(at: index)
    }

    private func undelete(at: IndexPath) {
        moveRow(from: at, toSection: 0, tableView: tableView)
    }
}

