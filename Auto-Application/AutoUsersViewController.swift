//
//  AutoUsersViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/15/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol AutoUserViewControllerInput: class {
    func didFetchAllUsersFromDatabase()
    func didHandleErrorFromFetchingUsersFromDatabase(error: String)
}
protocol AutoUserViewControllerOutput: class {
    func queryAllUsersFromDatabase()
    func deleteUserFromDatabase(userID:Int64)
    func selectedItemAt(indexPath: IndexPath) -> User
    func numberOfItemsInSection(section: Int) -> Int
    func removeItemAt(indexPath: IndexPath)
    func sendUserToNewUserVC(_ segue: UIStoryboardSegue, sender: Any?)
    func openNewUserVC(sender: Any?)
}
class AutoUsersViewController: UIViewController, PresenterAlertHandler, AutoUserViewControllerInput {
    fileprivate struct CellConstants {
        static let cellID = "AutoUserCell"
        static let cellNib = "AutoUsersTableViewCell"
        static let autoUserCellNib = "AutoTableViewCell"
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cellNib = UINib(nibName: CellConstants.cellNib, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: CellConstants.cellID)
            tableView.estimatedRowHeight = 100.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    var presenter: AutoUserPresenterInput!
    //MARK:-Loading
    override func awakeFromNib() {
        super.awakeFromNib()
        AutoUserAssembly.sharedInstance.buildAutoUserModule(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.presenter.queryAllUsersFromDatabase()
        }
    }
    //MARK:-AutoUserViewControllerInput
    func didFetchAllUsersFromDatabase() {
        self.tableView.reloadData()
    }
    func didHandleErrorFromFetchingUsersFromDatabase(error: String) {
        DispatchQueue.main.async {
            self.presentAlertWith(title: "Error", massage: error)
        }
    }
    //MARK:-Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter?.sendUserToNewUserVC(segue, sender: sender)
    }
}
extension AutoUsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfItemsInSection(section: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AutoUsersTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.cellID, for: indexPath) as! AutoUsersTableViewCell
        let user = presenter.selectedItemAt(indexPath: indexPath)
        cell.autoUser = user
        return cell
    }
}
extension AutoUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = presenter.selectedItemAt(indexPath: indexPath)
        presenter?.openNewUserVC(sender: user)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let user = presenter.selectedItemAt(indexPath: indexPath)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        presenter.removeItemAt(indexPath: indexPath)
        tableView.endUpdates()
        presenter?.deleteUserFromDatabase(userID: user.userID)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8, animations:{
            cell.alpha = 1
        })
        let rotationAngle = 90.0 * CGFloat(Double.pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 0, 0, 1)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.8, animations:{
            cell.layer.transform = CATransform3DIdentity
        })
    }
}
extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }else {
            return self
        }
    }
}

















