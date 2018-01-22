//
//  DatabaseManger.swift
//  Auto-Application
//
//  Created by warSong on 8/14/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation
import SQLite
protocol UsersDatabaseHandler: class {
    func addUser(user: User, onFailure:@escaping(_ error: String) -> ()) -> Int64?
    func queryAllUsers(onSucces:@escaping(_ users: [User]) -> (),
                       onFailure:@escaping(_ error: String) -> ())
    func updateUser(userID: Int64, newUser: User) -> Bool
    func deleteUser(userID: Int64)
}
class UserDatabaseManager: UsersDatabaseHandler {
    private static let _sharedManager = UserDatabaseManager()
    static var sharedManager: UserDatabaseManager {
        return _sharedManager
    }
    private let tblProduct = Table("UsersTable")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let imageName = Expression<String>("imageName")
    private let adress = Expression<String>("adress")
    private let db: Connection?
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/ishop.sqlite3")
            createTableProduct()
        }catch {
            db = nil
            print("ubable to open database")
        }
    }
    private func createTableProduct() {
        do {
            try db!.run(tblProduct.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(imageName)
                table.column(adress)
            })
        }catch {
            print("unable to create table")
        }
    }
    func addUser(user: User, onFailure:@escaping(_ error: String) -> ()) -> Int64? {
        do {
            let insert = tblProduct.insert(name <- user.name, imageName <- user.imageString, adress <- user.adress)
            let id = try db!.run(insert)
            return id
        }catch {
           onFailure("Error on add user")
            return nil
        }
    }
    func queryAllUsers(onSucces:@escaping(_ users: [User]) -> (),
                       onFailure:@escaping(_ error: String) -> ()) {
        do {
            var usersArray = [User]()
            for user in try db!.prepare(self.tblProduct) {
                let newUser = AutoUser(name: user[name], userID: user[id], imageString: user[imageName], adress: user[adress])
                usersArray.append(newUser)
            }
             onSucces(usersArray)
        }catch {
            onFailure("Fail on query users")
        }
    }
    func updateUser(userID: Int64, newUser: User) -> Bool{
        do {
            let tblFilterUser = tblProduct.filter(id == userID)
            let update = tblFilterUser.update([
                name <- newUser.name,
                imageName <- newUser.imageString,
                adress <- newUser.adress
                ])
            if try db!.run(update) > 0 {
                return true
            }
        }catch {
            print("error to update user")
            return false
        }
        return false
    }
    func deleteUser(userID: Int64) {
        do {
            let tblFilterUser = tblProduct.filter(id == userID)
            try db?.run(tblFilterUser.delete())
        }catch {
            print("error to delete user")
        }
    }
}
protocol CarsDatabaseHandler: class {
    func addCar(car: CarItem, onFailure:@escaping(_ error: String) -> ())
    func queryAllCars(onSucces:@escaping(_ cars: [CarItem]) -> (),
                       onFailure:@escaping(_ error: String) -> ())
    func queryUsersCar(usersID: Int64, onSuccess:@escaping(_ car: CarItem) ->(),
                       onFailure:@escaping(_ error: String) -> ())
    func updateCar(carID: Int64, newCar: CarItem)
    func deleteCar(carID: Int64)
}
class CarDatabaseManager: CarsDatabaseHandler  {
    private static let _sharedManager = CarDatabaseManager()
    static var sharedManager: CarDatabaseManager {
        return _sharedManager
    }
    private let tblProduct = Table("CarsTable")
    private let id = Expression<Int64>("carID")
    private let carName = Expression<String>("carName")
    private let carImage = Expression<String>("carImage")
    private let licensePlate = Expression<String>("licensePlate")
    private let userID = Expression<Int64>("userID")
    private let db: Connection?
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/ishop.sqlite3")
            createTableProduct()
        }catch {
            db = nil
            print("ubable to open database")
        }
    }
    private func createTableProduct() {
        do {
            try db!.run(tblProduct.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(carName)
                table.column(carImage)
                table.column(licensePlate)
                table.column(userID)
            })
        }catch {
            print("unable to create table")
        }
    }
    func addCar(car: CarItem, onFailure:@escaping(_ error: String) -> ()) {
        do {
            let insert = tblProduct.insert(carName <- car.carModel, carImage <- car.carImage, licensePlate <- car.licensePlate, userID <- car.userID)
            try db!.run(insert)
        }catch {
            onFailure("Error on add car")
        }
    }
    func queryAllCars(onSucces:@escaping(_ cars: [CarItem]) -> (),
                       onFailure:@escaping(_ error: String) -> ()) {
        do {
            var carsArray = [CarItem]()
            for car in try db!.prepare(self.tblProduct) {
                let newCar = Car(carModel: car[carName], carImage: car[carImage], carID: car[id], licensePlate: car[licensePlate], userID: car[userID])
                carsArray.append(newCar)
            }
            onSucces(carsArray)
        }catch {
            onFailure("Fail on query cars")
        }
    }
    func queryUsersCar(usersID: Int64, onSuccess:@escaping(_ car: CarItem) ->(), onFailure:@escaping(_ error: String) -> ()) {
        do {
            let query = tblProduct.filter(userID == usersID)
            for car in try db!.prepare(query) {
                let usersCar = Car(carModel: car[carName], carImage: car[carImage], carID: car[id], licensePlate: car[licensePlate], userID: car[userID])
                onSuccess(usersCar)
            }
        }catch {
            onFailure("error to load users Cars")
        }
    }
    func updateCar(carID: Int64, newCar: CarItem) {
        do {
            let tblFilterCar = tblProduct.filter(id == carID)
            let update = tblFilterCar.update([
                carName <- newCar.carModel,
                carImage <- newCar.carImage,
                licensePlate <- newCar.licensePlate,
                userID <- newCar.userID
                ])
            if try db!.run(update) > 0 {
                
            }
        }catch {
            print("error to update car")
        }
    }
    func deleteCar(carID: Int64) {
        do {
            let tblFilterUser = tblProduct.filter(id == carID)
            try db?.run(tblFilterUser.delete())
        }catch {
            print("error to delete car")
        }
    }
}













