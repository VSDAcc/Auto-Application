//
//  NewUserTableViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/16/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol SaveNewUserHandler: class {
    func saveNewUser(newUser: User, userCars: [CarItem])
    func updateUser(userID: Int64, newUser: User, userCars: [CarItem])
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
        static let carCellID = "CarCell"
        static let carCellNIB = "CarTableViewCell"
        static let accountInfoCell = "AccountInfo"
        static let accountInfoNIB = "ProfileInfoTableViewCell"
        static let showCarsControllerCell = "ShowCarsControllerCell"
        static let showCarsControllerNIB = "AddUserCarsRowTableViewCell"
    }
    private func registerCarCellToTableview() {
        let carCellNib = UINib(nibName: CellConstants.carCellNIB, bundle: nil)
        let accountCellNib = UINib(nibName: CellConstants.accountInfoNIB, bundle: nil)
        let showCarsCellNib = UINib(nibName: CellConstants.showCarsControllerNIB, bundle: nil)
        tableView.register(carCellNib, forCellReuseIdentifier: CellConstants.carCellID)
        tableView.register(accountCellNib, forCellReuseIdentifier: CellConstants.accountInfoCell)
        tableView.register(showCarsCellNib, forCellReuseIdentifier: CellConstants.showCarsControllerCell)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    weak var profileAccountTableViewCell: ProfileInfoTableViewCell? {
        didSet {
            if user != nil {
                profileAccountTableViewCell?.avatarImageView.image = UIImage(named: user!.imageString)
                profileAccountTableViewCell?.userNameTextField.text = user!.name
                profileAccountTableViewCell?.userAdressTextField.text = user!.adress
            }
        }
    }
    weak var showCarsTableViewCell: AddUserCarsRowTableViewCell?
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
    //MARK:-Database
    func saveNewUser(_ sender: UIBarButtonItem) {
        if !profileAccountTableViewCell!.userNameTextField.text!.isEmpty && !profileAccountTableViewCell!.userAdressTextField.text!.isEmpty {
            _ = self.navigationController?.popViewController(animated: true)
            if user != nil {
                let newUser = AutoUser(name: profileAccountTableViewCell!.userNameTextField.text!, userID: user!.userID, imageString: "driver.png", adress: profileAccountTableViewCell!.userAdressTextField.text!)
                delegate?.updateUser(userID: user!.userID, newUser: newUser, userCars: userCars)
            }else {
                let newUser = AutoUser(name: profileAccountTableViewCell!.userNameTextField.text!, imageString: "driver.jpeg", adress: profileAccountTableViewCell!.userAdressTextField.text!)
                delegate?.saveNewUser(newUser: newUser, userCars: userCars)
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
        let cell: CarTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.carCellID, for: indexPath) as! CarTableViewCell
        let car = self.userCars[indexPath.row]
        cell.car = car
            return cell
        }else if indexPath.section == Sections.profileSection && indexPath.row == ProfileRow.accountRow {
            profileAccountTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.accountInfoCell, for: indexPath) as? ProfileInfoTableViewCell
            profileAccountTableViewCell?.userNameTextField.delegate = self
            profileAccountTableViewCell?.userAdressTextField.delegate = self
            return profileAccountTableViewCell!
        }else {
            showCarsTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.showCarsControllerCell, for: indexPath) as? AddUserCarsRowTableViewCell
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == Sections.usersCarsSection {
            return true
        }else {
            return false
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == Sections.usersCarsSection {
        let car = self.userCars[indexPath.row]
        tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.userCars.remove(at: indexPath.row)
        tableView.endUpdates()
            if user != nil {
                let newCar = Car(carModel: car.carModel, carImage: car.carImage, carID: car.carID, licensePlate: car.licensePlate, userID: 0)
                carsDatabaseDelegate?.updateCar(carID: car.carID, newCar: newCar)
            }
        }
    }
}
extension NewUserTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  profileAccountTableViewCell!.userNameTextField.isFirstResponder {
            profileAccountTableViewCell!.userAdressTextField.becomeFirstResponder()
        }else if profileAccountTableViewCell!.userAdressTextField.isFirstResponder {
            profileAccountTableViewCell!.userAdressTextField.resignFirstResponder()
        }
        return true
    }
}
