//
//  CarsViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/16/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit

class CarsViewController: UIViewController, PresenterAlertHandler {
    struct CellConstants {
        static let cellID = "CarCell"
        static let cellNIB = "CarTableViewCell"
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cellNib = UINib(nibName: CellConstants.cellNIB, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: CellConstants.cellID)
            tableView.estimatedRowHeight = 100.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    weak var carsDatabaseDelegate: CarsDatabaseHandler?
    var cars = [CarItem]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        carsDatabaseDelegate = CarDatabaseManager.sharedManager
        insertCarsToDatabase()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCarsFromDB()
    }
    private func loadCarsFromDB() {
        carsDatabaseDelegate?.queryAllCars(onSucces: { [unowned self](carsArray) in
            self.cars = carsArray
            }, onFailure: { (error) in
                DispatchQueue.main.async {
                    self.presentAlertWith(title: "Error", massage: error)
                }
        })
    }
    private func insertCarsToDatabase() {
        for _ in 1...10 {
            let car = Car(carModel: "BMW", carImage: "car.png", licensePlate: "030043504305")
            carsDatabaseDelegate?.addCar(car: car, onFailure: { [unowned self](error) in
                self.presentAlertWith(title: "error", massage: error)
            })
        }
    }
}
extension CarsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CarTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellConstants.cellID, for: indexPath) as! CarTableViewCell
        let car = self.cars[indexPath.row]
        cell.car = car
        return cell
    }
}
extension CarsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let car = self.cars[indexPath.row]
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        self.cars.remove(at: indexPath.row)
        tableView.endUpdates()
        carsDatabaseDelegate?.deleteCar(carID: car.carID)
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
}
