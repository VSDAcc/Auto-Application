//
//  AutoUsersViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/15/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
class AutoUsersViewController: UIViewController, SaveNewUserHandler {
    struct CellConstants {
        static let cellID = "AutoUserCell"
        static let cellNIB = "AutoUsersTableViewCell"
    }
    struct Segues {
        static let newUserSegue = "newUserSegue"
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cellNib = UINib(nibName: CellConstants.cellNIB, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: CellConstants.cellID)
            tableView.estimatedRowHeight = 80.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    weak var usersDatabaseDelegate: UsersDatabaseHandler?
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usersDatabaseDelegate = DatabaseManager.sharedManager
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUsersFromDB()
    }
    private func loadUsersFromDB() {
        usersDatabaseDelegate?.queryAllUsers(onSucces: { [unowned self](usersArray) in
            self.users = usersArray
            }, onFailure: { (error) in
                print(error)
        })
    }
    //MARK:-SaveNewUserHandler 
    func saveNewUser(name: String, avatarImage: String) {
        usersDatabaseDelegate?.addUser(inputName: name, inputImageName: avatarImage, onFailure: { (error) in
            print(error)
        })
    }
    func updateUser(userID: Int64, newUser: User) {
        usersDatabaseDelegate?.updateUser(userID: userID, newUser: newUser)
    }
    //MARK:-Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.newUserSegue {
            if let destinationVC = segue.destination.contentViewController as? NewUserTableViewController {
                destinationVC.delegate = self
                if let user = sender as? User {
                    destinationVC.user = user
                }
            }
        }
    }
}
extension AutoUsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AutoUsersTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.cellID, for: indexPath) as! AutoUsersTableViewCell
        let user = self.users[indexPath.row]
        cell.autoUser = user
        return cell
    }
}
extension AutoUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.users[indexPath.row]
        performSegue(withIdentifier: Segues.newUserSegue, sender: user)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        self.users.remove(at: indexPath.row)
        tableView.endUpdates()
        usersDatabaseDelegate?.deleteUser(userID: user.userID)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
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
















