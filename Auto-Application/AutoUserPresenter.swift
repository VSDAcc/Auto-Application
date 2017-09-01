//
//  AutoUserPresenter.swift
//  Auto-Application
//
//  Created by warSong on 8/28/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol AutoUserPresenterInput: AutoUserInteractorOutput, AutoUserViewControllerOutput {
}
protocol AutoUserPresenterOutput: AutoUserViewControllerInput {
}
class AutoUserPresenter: AutoUserPresenterInput {
    
    var interactor: AutoUserInteractorInput!
    weak var view: AutoUserViewControllerInput!
    var router: AutoUserRouterInput!
    
    //MARK:-ModuleInput

    //MARK:-Interactor
    func queryAllUsersFromDatabase() {
        interactor.queryAllUsersFromDatabase()
    }
    func deleteUserFromDatabase(userID:Int64) {
        interactor.deleteUserFromDatabase(userID: userID)
    }
    //MARK:-View
    func didFetchAllUsersFromDatabase(usersArray: [User]) {
        view.didFetchAllUsersFromDatabase(usersArray: usersArray)
    }
    func didHandleErrorFromFetchingUsersFromDatabase(error: String) {
        view.didHandleErrorFromFetchingUsersFromDatabase(error: error)
    }
    //MARK:-Router
    func sendUserToNewUserVC(_ segue: UIStoryboardSegue, sender: Any?) {
        router.sendUserToNewUserVC(segue,sender: sender)
    }
    func openNewUserVC(sender: Any?) {
        router.openNewUserVC(sender: sender)
    }
}








