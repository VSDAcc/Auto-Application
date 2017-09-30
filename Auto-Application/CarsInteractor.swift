//
//  CarsInteractor.swift
//  Auto-Application
//
//  Created by warSong on 9/1/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation
protocol CarsInteractorInput: class {
    func queryAllCarsFromDatabase()
    func addMoreCarsToDatabase()
    func deleteCarFromDatabase(carID: Int64)
}
protocol CarsInteractorOutput: class {
    func didFetchAllCarsFromDatabase(userCars: [CarItem])
    func didHandleErrorFromFetchingDatabase(error: String)
}
class CarsInteractor: CarsInteractorInput {
    
    var carDatabase: CarsDatabaseHandler?
    weak var presenter: CarsPresenterInput!
    
    func queryAllCarsFromDatabase() {
        carDatabase?.queryAllCars(onSucces: { [weak self] (carsArray) in
            self?.presenter.didFetchAllCarsFromDatabase(userCars: carsArray)
            }, onFailure: { [weak self] (error) in
                self?.presenter.didHandleErrorFromFetchingDatabase(error: error)
        })
    }
    func addMoreCarsToDatabase() {
        for _ in 1...10 {
            let car = Car(carModel: "BMW", carImage: "car.png", licensePlate: "030043504305", userID: 0)
            carDatabase?.addCar(car: car, onFailure: { [weak self] (error) in
                self?.presenter.didHandleErrorFromFetchingDatabase(error: error)
            })
        }
        queryAllCarsFromDatabase()
    }
    func deleteCarFromDatabase(carID: Int64) {
        carDatabase?.deleteCar(carID: carID)
    }
}
