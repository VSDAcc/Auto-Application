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
}
protocol AutoUserInteractorOutput: class {
    func fetchAllUsersFromDatabase(usersArray: [User])
    func handleErrorFromFetchingUsersFromDatabase(error: String)
}
class AutoUserInteractor: AutoUserInteractorInput {

    var userDatabase: UsersDatabaseHandler?
    weak var presenter: AutoUserPresenterInput?
    func queryAllUsersFromDatabase() {
        userDatabase?.queryAllUsers(onSucces: { (usersArray) in
            self.presenter?.fetchAllUsersFromDatabase(usersArray: usersArray)
        }, onFailure: { (error) in
            self.presenter?.handleErrorFromFetchingUsersFromDatabase(error: error)
        })
    }
    func deleteUserFromDatabase(userID:Int64) {
        userDatabase?.deleteUser(userID: userID)
    }
}





