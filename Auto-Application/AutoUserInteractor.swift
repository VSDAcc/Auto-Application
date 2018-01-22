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
    func didFetchAllUsersFromDatabase(usersArray: [User])
    func didHandleErrorFromFetchingUsersFromDatabase(error: String)
}
class AutoUserInteractor: AutoUserInteractorInput {

    var userDatabase: UsersDatabaseHandler?
    weak var presenter: AutoUserPresenterInput!
    func queryAllUsersFromDatabase() {
        userDatabase?.queryAllUsers(onSucces: { [weak self] (usersArray) in
            self?.presenter.didFetchAllUsersFromDatabase(usersArray: usersArray)
        }, onFailure: { [weak self] (error) in
            self?.presenter.didHandleErrorFromFetchingUsersFromDatabase(error: error)
        })
    }
    func deleteUserFromDatabase(userID:Int64) {
        userDatabase?.deleteUser(userID: userID)
    }
}





