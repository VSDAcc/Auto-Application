//
//  AutoUserPresenter.swift
//  Auto-Application
//
//  Created by warSong on 8/28/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol AutoUserPresenterInput: AutoUserInteractorOutput, AutoUserViewControllerOutput, AutouserRouterOutput {
    var interactor: AutoUserInteractorInput? {get}
    weak var view: AutoUserViewControllerInput? {get}
    var router: AutoUserRouterInput? {get}
}
protocol AutoUserPresenterOutput: AutoUserViewControllerInput {
}
class AutoUserPresenter: AutoUserPresenterInput {
    
    var interactor: AutoUserInteractorInput?
    weak var view: AutoUserViewControllerInput?
    var router: AutoUserRouterInput?
    
    func queryAllUsersFromDatabase() {
        interactor?.queryAllUsersFromDatabase()
    }
    func deleteUserFromDatabase(userID:Int64) {
        interactor?.deleteUserFromDatabase(userID: userID)
    }
    func fetchAllUsersFromDatabase(usersArray: [User]) {
        view?.fetchAllUsersFromDatabase(usersArray: usersArray)
    }
    func handleErrorFromFetchingUsersFromDatabase(error: String) {
        view?.handleErrorFromFetchingUsersFromDatabase(error: error)
    }
    func sendUserToNewUserVC(_ segue: UIStoryboardSegue, sender: Any?) {
        router?.sendUserToNewUserVC(segue,sender: sender)
    }
    func perfomSegueToNewUserVC(sender: Any?) {
        router?.perfomSegueToNewUserVC(sender: sender)
    }
}








