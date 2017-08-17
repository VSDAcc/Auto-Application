//
//  NewUserTableViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/16/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol SaveNewUserHandler: class {
    func saveNewUser(newUser: User)
    func updateUser(userID: Int64, newUser: User)
}
class NewUserTableViewController: UITableViewController, PresenterAlertHandler {
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            if user != nil {
                avatarImageView.image = UIImage(named: user!.imageString)
            }
        }
    }
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            DispatchQueue.main.async {
                self.userNameTextField.becomeFirstResponder()
            }
            if user != nil {
                userNameTextField.text = user!.name
                userNameTextField.delegate = self
            }
        }
    }
    @IBOutlet weak var userAdressTextField: UITextField! {
        didSet {
            if user != nil {
                userAdressTextField.text = user!.adress
                userAdressTextField.delegate = self
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
        if !userNameTextField.text!.isEmpty && !userAdressTextField.text!.isEmpty {
            _ = self.navigationController?.popViewController(animated: true)
            if user != nil {
                let newUser = AutoUser(name: userNameTextField.text!, userID: user!.userID, imageString: "driver.png", adress: userAdressTextField.text!)
                delegate?.updateUser(userID: user!.userID, newUser: newUser)
            }else {
                let newUser = AutoUser(name: userNameTextField.text!, imageString: "driver.jpeg", adress: userAdressTextField.text!)
                delegate?.saveNewUser(newUser: newUser)
            }
        }else {
            DispatchQueue.main.async {
                self.presentAlertWith(title: "Error", massage: "Please fill User name or adress")
            }
        }
    }
    //MARK:-UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension NewUserTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(userNameTextField.text?.isEmpty)! && userNameTextField.isFirstResponder {
            userAdressTextField.becomeFirstResponder()
        }else if userAdressTextField.isFirstResponder {
            userAdressTextField.resignFirstResponder()
        }
        return true
    }
}
