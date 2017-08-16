//
//  NewUserTableViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/16/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol SaveNewUserHandler: class {
    func saveNewUser(name: String, avatarImage: String)
    func updateUser(userID: Int64, newUser: User)
}
class NewUserTableViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            if user != nil {
                avatarImageView.image = UIImage(named: user!.imageString)
            }
        }
    }
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            if user != nil {
                userNameTextField.text = user!.name
            }
        }
    }
    weak var delegate: SaveNewUserHandler?
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    private func configureNavigationBar() {
        navigationItem.title = "New User"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewUser(_ :)))
    }
    func saveNewUser(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
        if user != nil {
            let newUser = AutoUser(name: userNameTextField.text!, userID: user!.userID, imageString: "account.jpeg")
            delegate?.updateUser(userID: user!.userID, newUser: newUser)
        }else {
            delegate?.saveNewUser(name: userNameTextField.text!, avatarImage: "account.jpeg")
        }
    }
    //MARK:-UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
