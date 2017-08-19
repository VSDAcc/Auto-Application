//
//  ShowCarsTableViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/19/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol HandleChoocenCarsForUser: class {
    func saveChoocenCars(cars: [CarItem])
}
class ShowCarsTableViewController: UITableViewController, PresenterAlertHandler {
    
    struct CellConstants {
        static let cellID = "ShowCarsCell"
        static let cellNIB = "ShowCarsTableViewCell"
    }
    private func registerCarCellToTableview() {
        let cellNib = UINib(nibName: CellConstants.cellNIB, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CellConstants.cellID)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    weak var carsDatabaseDelegate: CarsDatabaseHandler?
    weak var handleUsersCarsDelegate: HandleChoocenCarsForUser?
    var cars = [CarItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    var user: User?
    var usersCars = [CarItem]()
    //MARL:-Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCarCellToTableview()
        carsDatabaseDelegate = CarDatabaseManager.sharedManager
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCarsFromDB()
        configureNavigationBar()
    }
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUsersCars(_ :)))
    }
    func saveUsersCars(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
        handleUsersCarsDelegate?.saveChoocenCars(cars: usersCars)
    }
    //MARK:-Database
    private func loadCarsFromDB() {
        carsDatabaseDelegate?.queryAllCars(onSucces: { [unowned self] (carsArray) in
            self.cars = carsArray
            }, onFailure: { (error) in
                DispatchQueue.main.async {
                    self.presentAlertWith(title: "Error", massage: error)
                }
        })
    }
    //MARK:-UITableViewDatasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShowCarsTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.cellID, for: indexPath) as! ShowCarsTableViewCell
        let car = self.cars[indexPath.row]
        cell.car = car
        if usersCars.contains(where: {$0.userID == car.userID}) {
            cell.checkMarkLabel.text = "In list"
        }else {
            cell.checkMarkLabel.text = usersCars.contains(where: {$0.userID == car.userID}) ? "✓" : ""
        }
        return cell
    }
    //MARK:-UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let car = self.cars[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) as? ShowCarsTableViewCell {
            if  !(cell.checkMarkLabel.text == "✓") {
                usersCars.append(car)
                cell.checkMarkLabel.text = "✓"
            }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}














