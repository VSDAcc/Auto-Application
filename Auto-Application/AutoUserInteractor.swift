//
//  AutoUserInteractor.swift
//  Auto-Application
//
//  Created by warSong on 8/28/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation
protocol AutoUserInteractorInput: class {
    func queryAllUsersFromDatabase()
    func deleteUserFromDatabase(userID:Int64)
    func selectedItemAt(indexPath: IndexPath) -> User
    func numberOfItemsInSection(section: Int) -> Int
    func removeItemAt(indexPath: IndexPath)
}
protocol AutoUserInteractorOutput: class {
    func didFetchAllUsersFromDatabase()
    func didHandleErrorFromFetchingUsersFromDatabase(error: String)
}
class AutoUserInteractor: AutoUserInteractorInput {

    var userDatabase: UsersDatabaseHandler?
    weak var presenter: AutoUserPresenterInput!
    fileprivate var users = [User]()
    func queryAllUsersFromDatabase() {
        userDatabase?.queryAllUsers(onSucces: { [weak self] (usersArray) in
            self?.users = usersArray
            self?.presenter.didFetchAllUsersFromDatabase()
        }, onFailure: { [weak self] (error) in
            self?.presenter.didHandleErrorFromFetchingUsersFromDatabase(error: error)
        })
    }
    func deleteUserFromDatabase(userID:Int64) {
        userDatabase?.deleteUser(userID: userID)
    }
    func selectedItemAt(indexPath: IndexPath) -> User {
        return users[indexPath.item]
    }
    func numberOfItemsInSection(section: Int) -> Int {
        return users.count
    }
    func removeItemAt(indexPath: IndexPath) {
        users.remove(at: indexPath.item)
    }
}





