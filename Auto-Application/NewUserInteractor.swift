//
//  NewUserInteractor.swift
//  Auto-Application
//
//  Created by warSong on 8/29/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation
protocol NewUserInteractorInput: class {
    func queryAllUserCarsFromDatabase(userID: Int64)
    func saveNewUserToDatabase(newUser: User, userCars: [CarItem])
    func updateUserToDatabase(userID: Int64, newUser: User, userCars: [CarItem])
    func updateUserCarToDatabase(carID: Int64, newCar: CarItem)
    func saveUserFromAutoUserVC(_ user: User)
}
protocol NewUserInteractorOutput: class {
    func didFetchUserCarFromDatabase(userCar: CarItem)
    func didHandleErrorFromFetchingDatabase(error: String)
    func didFetchUserFromAutoUserVC(_ user: User)
}
class NewUserInteractor: NewUserInteractorInput {
    
    var userDatabase: UsersDatabaseHandler?
    var carDatabase: CarsDatabaseHandler?
    weak var presenter: NewUserPresenterInput!
    var user: User?
    //MARK:-RoutinInputData
    func saveUserFromAutoUserVC(_ user: User) {
        presenter.didFetchUserFromAutoUserVC(user)
    }
    //MARK:-UserDatabase
    func updateUserToDatabase(userID: Int64, newUser: User, userCars: [CarItem]) {
        if userDatabase!.updateUser(userID: userID, newUser: newUser) {
            updateAllUsersCarsToDatabase(userCars: userCars, userID: userID)
        }
    }
    func saveNewUserToDatabase(newUser: User, userCars: [CarItem]) {
        if let newUserID = userDatabase?.addUser(user: newUser, onFailure: { [unowned self] (error) in
            self.presenter.didHandleErrorFromFetchingDatabase(error: error)
        }) {
            self.updateAllUsersCarsToDatabase(userCars: userCars, userID: newUserID)
        }
    }
    //MARK:-CarDatabase
    func queryAllUserCarsFromDatabase(userID: Int64) {
        carDatabase?.queryUsersCar(usersID: userID, onSuccess: { [unowned self] (car) in
            self.presenter.didFetchUserCarFromDatabase(userCar: car)
        }, onFailure: { [unowned self] (error) in
            self.presenter.didHandleErrorFromFetchingDatabase(error: error)
        })
    }
    func updateUserCarToDatabase(carID: Int64, newCar: CarItem) {
        carDatabase?.updateCar(carID: carID, newCar: newCar)
    }
    private func updateAllUsersCarsToDatabase(userCars: [CarItem], userID: Int64) {
        for car in userCars {
            let newCar = Car(carModel: car.carModel, carImage: car.carImage, licensePlate: car.licensePlate, userID: userID)
            carDatabase?.updateCar(carID: car.carID, newCar:newCar)
        }
    }
}
