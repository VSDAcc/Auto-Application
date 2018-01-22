//
//  CarsViewController.swift
//  Auto-Application
//
//  Created by warSong on 8/16/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol CarsViewControllerInput: class {
    func didFetchAllCarsFromDatabase(userCars: [CarItem])
    func didHandleErrorFromFetchingDatabase(error: String)
}
protocol CarsViewControllerOutput: class {
    func queryAllCarsFromDatabase()
    func addMoreCarsToDatabase()
    func deleteCarFromDatabase(carID: Int64)
}
class CarsViewController: UIViewController, PresenterAlertHandler, CarsViewControllerInput {
    fileprivate struct CellConstants {
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
    var presenter: CarsPresenterInput!
    fileprivate var cars = [CarItem]() {
        didSet {
            print("reloaded")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //MARK:-Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.presenter.queryAllCarsFromDatabase()
        }
    }
    private func configureNavigationBar() {
        navigationItem.title = "Cars"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCars(_ :)))
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        CarsAssembly.sharedInstance.buildAutoUserModule(self)
    }
    //MARK:-Actions
    func addCars(_ sender: UIBarButtonItem) {
        presenter.addMoreCarsToDatabase()
    }
    //MARK:-CarsViewControllerInput
    func didFetchAllCarsFromDatabase(userCars: [CarItem]) {
        self.cars = userCars
    }
    func didHandleErrorFromFetchingDatabase(error: String) {
        DispatchQueue.main.async {
            self.presentAlertWith(title: "Error", massage: error)
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
        presenter.deleteCarFromDatabase(carID: car.carID)
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
