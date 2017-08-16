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
    func addUser(inputName: String, inputImageName: String,
                 onFailure:@escaping(_ error: String) -> ())
    func queryAllUsers(onSucces:@escaping(_ users: [User]) -> (),
                       onFailure:@escaping(_ error: String) -> ())
    func updateUser(userID: Int64, newUser: User)
    func deleteUser(userID: Int64)
}
class DatabaseManager: UsersDatabaseHandler {
    private static let _sharedManager = DatabaseManager()
    static var sharedManager: DatabaseManager {
        return _sharedManager
    }
    private let tblProduct = Table("Users")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let imageName = Expression<String>("imageName")
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
            })
            print("created table successfully")
        }catch {
            print("unable to create table")
        }
    }
    func addUser(inputName: String, inputImageName: String, onFailure:@escaping(_ error: String) -> ()) {
        do {
            let insert = tblProduct.insert(name <- inputName, imageName <- inputImageName)
            try db!.run(insert)
        }catch {
           onFailure("Error on add user")
        }
    }
    func queryAllUsers(onSucces:@escaping(_ users: [User]) -> (),
                       onFailure:@escaping(_ error: String) -> ()) {
        do {
            var usersArray = [User]()
            for user in try db!.prepare(self.tblProduct) {
                let newUser = AutoUser(name: user[name], userID: user[id], imageString: user[imageName])
                usersArray.append(newUser)
                onSucces(usersArray)
            }
        }catch {
            onFailure("Fail on query users")
        }
    }
    func updateUser(userID: Int64, newUser: User) {
        do {
            let tblFilterUser = tblProduct.filter(id == userID)
            let update = tblFilterUser.update([
                name <- newUser.name,
                imageName <- newUser.imageString
                ])
            if try db!.run(update) > 0 {
                
            }
        }catch {
            print("error to update user")
        }
    }
    func deleteUser(userID: Int64) {
        do {
            let tblFilterUser = tblProduct.filter(id == userID)
            try db?.run(tblFilterUser.delete())
        }catch {
        }
    }
}














