//
//  NewUserTableViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/16/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol NewUserTableViewControllerInput: class {
    func didFetchUserCarFromDatabase(userCar: CarItem)
    func didHandleErrorFromFetchingDatabase(error: String)
    func didFetchUserFromAutoUserVC(_ user: User)
    func didFetchUserCarsFromShowCarsVC(_ userCars: [CarItem])
}
protocol NewUserTableViewControllerOutput: class {
    func queryAllUserCarsFromDatabase(userID: Int64)
    func saveNewUserToDatabase(newUser: User, userCars: [CarItem])
    func updateUserToDatabase(userID: Int64, newUser: User, userCars: [CarItem])
    func updateUserCarToDatabase(carID: Int64, newCar: CarItem)
    func sendUserToShowCarsVC(_ segue: UIStoryboardSegue, sender: Any?)
    func openShowCarsVC(sender: Any?)
    func fetchUserFromAutoUserVC(_ user: User)
}
class NewUserTableViewController: UITableViewController, PresenterAlertHandler, NewUserTableViewControllerInput {
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
    var presenter: NewUserPresenterInput!
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
        registerCarCellToTableview()
        if user != nil {
            presenter.queryAllUserCarsFromDatabase(userID: user!.userID)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        NewUserAssembly.sharedInstance.buildNewUserModule(self)
    }
    private func configureNavigationBar() {
        navigationItem.title = "User"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewUser(_ :)))
    }
    //MARK:-NewUserViewControllerInput
    func didFetchUserCarFromDatabase(userCar: CarItem) {
        self.userCars.append(userCar)
    }
    func didHandleErrorFromFetchingDatabase(error: String) {
        DispatchQueue.main.async {
            self.presentAlertWith(title: "Error", massage: error)
        }
    }
    func didFetchUserFromAutoUserVC(_ user: User) {
        self.user = user
    }
    func didFetchUserCarsFromShowCarsVC(_ userCars: [CarItem]) {
        self.userCars = userCars
    }
    //MARK:-Actions
    func saveNewUser(_ sender: UIBarButtonItem) {
        if !profileAccountTableViewCell!.userNameTextField.text!.isEmpty && !profileAccountTableViewCell!.userAdressTextField.text!.isEmpty {
            _ = self.navigationController?.popViewController(animated: true)
            if user != nil {
                let newUser = AutoUser(name: profileAccountTableViewCell!.userNameTextField.text!, userID: user!.userID, imageString: "driver.png", adress: profileAccountTableViewCell!.userAdressTextField.text!)
                presenter.updateUserToDatabase(userID: user!.userID, newUser: newUser, userCars: userCars)
            }else {
                let newUser = AutoUser(name: profileAccountTableViewCell!.userNameTextField.text!, imageString: "driver.jpeg", adress: profileAccountTableViewCell!.userAdressTextField.text!)
                presenter.saveNewUserToDatabase(newUser: newUser, userCars: userCars)
            }
        }else {
            DispatchQueue.main.async {
                self.presentAlertWith(title: "Error", massage: "Please fill User name or adress")
            }
        }
    }
    //MAR:-Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if user != nil {
            presenter.sendUserToShowCarsVC(segue, sender: sender)
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
            presenter.openShowCarsVC(sender: nil)
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
                presenter.updateUserCarToDatabase(carID: car.carID, newCar: newCar)
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
