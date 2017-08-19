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
class NewUserTableViewController: UITableViewController, PresenterAlertHandler, HandleChoocenCarsForUser {
    struct Segues {
        static let showUsersCars = "ShowCars"
    }
    struct Sections {
        static let profileSection = 0
        static let usersCarsSection = 1
    }
    struct ProfileRow {
        static let accountRow = 0
        static let addCarRow = 1
    }
    struct CellConstants {
        static let cellID = "CarCell"
        static let cellNIB = "CarTableViewCell"
        static let accountInfoCell = "AccountInfo"
        static let showCarsControllerCell = "ShowCarsControllerCell"
    }
    private func registerCarCellToTableview() {
        let cellNib = UINib(nibName: CellConstants.cellNIB, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CellConstants.cellID)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    weak var profileAccountTableViewCell: ProfileTableViewCell? {
        didSet {
            if user != nil {
                profileAccountTableViewCell?.avatarImageView.image = UIImage(named: user!.imageString)
                profileAccountTableViewCell?.userNameTextField.text = user!.name
                profileAccountTableViewCell?.userNameTextField.delegate = self
                profileAccountTableViewCell?.userAdressTextField.text = user!.adress
                profileAccountTableViewCell?.userAdressTextField.delegate = self
            }
        }
    }
    weak var showCarsTableViewCell: AddRowTableViewCell?
    weak var delegate: SaveNewUserHandler?
    weak var carsDatabaseDelegate: CarsDatabaseHandler?
    var user: User?
    var userCars = [CarItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    //MARK:-Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        carsDatabaseDelegate = CarDatabaseManager.sharedManager
        registerCarCellToTableview()
        loadUserCarsFromDB()
    }
    private func configureNavigationBar() {
        navigationItem.title = "User"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewUser(_ :)))
    }
    //MARK:-HandleChoocenCarsForUser
    func saveChoocenCars(cars: [CarItem]) {
        userCars = cars
    }
    private func updateUsersCarsToDB(userID: Int64) {
        for car in userCars {
            let newCar = Car(carModel: car.carModel, carImage: car.carImage, licensePlate: car.licensePlate, userID: userID)
            carsDatabaseDelegate?.updateCar(carID: car.carID, newCar:newCar)
        }
    }
    //MARK:-Database
    func saveNewUser(_ sender: UIBarButtonItem) {
        if !profileAccountTableViewCell!.userNameTextField.text!.isEmpty && !profileAccountTableViewCell!.userAdressTextField.text!.isEmpty {
            _ = self.navigationController?.popViewController(animated: true)
            if user != nil {
                let newUser = AutoUser(name: profileAccountTableViewCell!.userNameTextField.text!, userID: user!.userID, imageString: "driver.png", adress: profileAccountTableViewCell!.userAdressTextField.text!)
                delegate?.updateUser(userID: user!.userID, newUser: newUser)
                updateUsersCarsToDB(userID: newUser.userID)
            }else {
                let newUser = AutoUser(name: profileAccountTableViewCell!.userNameTextField.text!, imageString: "driver.jpeg", adress: profileAccountTableViewCell!.userAdressTextField.text!)
                delegate?.saveNewUser(newUser: newUser)
                updateUsersCarsToDB(userID: newUser.userID)
            }
        }else {
            DispatchQueue.main.async {
                self.presentAlertWith(title: "Error", massage: "Please fill User name or adress")
            }
        }
    }
    private func loadUserCarsFromDB() {
        if user != nil {
            carsDatabaseDelegate?.queryUsersCar(usersID: user!.userID, onSuccess: { [unowned self] (carItem) in
                self.userCars.append(carItem)
                }, onFailure: { (error) in
                    DispatchQueue.main.async {
                        self.presentAlertWith(title: "Error", massage: error)
                    }
            })
        }
    }
    //MAR:-Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.showUsersCars {
            if let destinationVC = segue.destination.contentViewController as? ShowCarsTableViewController {
                destinationVC.handleUsersCarsDelegate = self
                if user != nil {
                destinationVC.user = self.user
                destinationVC.usersCars = self.userCars
                }
            }
        }
    }
    //MARK:-UITableViewDatasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Sections.usersCarsSection {
            return userCars.count
        }else {
            return 2
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Sections.usersCarsSection {
        let cell: CarTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.cellID, for: indexPath) as! CarTableViewCell
        let car = self.userCars[indexPath.row]
        cell.car = car
            return cell
        }else if indexPath.section == Sections.profileSection && indexPath.row == ProfileRow.accountRow {
            profileAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.accountInfoCell, for: indexPath) as? ProfileTableViewCell
            return profileAccountTableViewCell!
        }else {
            showCarsTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.showCarsControllerCell, for: indexPath) as? AddRowTableViewCell
            return showCarsTableViewCell!
        }
    }
    //MARK:-UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == Sections.profileSection && indexPath.row == ProfileRow.addCarRow {
            performSegue(withIdentifier: Segues.showUsersCars, sender: self)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Sections.profileSection && indexPath.row == ProfileRow.accountRow {
            return 220.0
        }else if indexPath.section == Sections.profileSection && indexPath.row == ProfileRow.addCarRow {
            return 70.0
        }else {
            return 100.0
        }
    }
}
extension NewUserTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(profileAccountTableViewCell!.userNameTextField.text?.isEmpty)! && profileAccountTableViewCell!.userNameTextField.isFirstResponder {
            profileAccountTableViewCell!.userAdressTextField.becomeFirstResponder()
        }else if profileAccountTableViewCell!.userAdressTextField.isFirstResponder {
            profileAccountTableViewCell!.userAdressTextField.resignFirstResponder()
        }
        return true
    }
}
