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
        DispatchQueue.global(qos: .userInteractive).async {
            self.interactor.queryAllUsersFromDatabase()
        }
    }
    func deleteUserFromDatabase(userID:Int64) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.interactor.deleteUserFromDatabase(userID: userID)
        }
    }
    func selectedItemAt(indexPath: IndexPath) -> User {
        return interactor.selectedItemAt(indexPath: indexPath)
    }
    func numberOfItemsInSection(section: Int) -> Int {
        return interactor.numberOfItemsInSection(section: section)
    }
    func removeItemAt(indexPath: IndexPath) {
        interactor.removeItemAt(indexPath: indexPath)
    }
    //MARK:-View
    func didFetchAllUsersFromDatabase() {
        DispatchQueue.main.async {
            self.view.didFetchAllUsersFromDatabase()
        }
    }
    func didHandleErrorFromFetchingUsersFromDatabase(error: String) {
        DispatchQueue.main.async {
            self.view.didHandleErrorFromFetchingUsersFromDatabase(error: error)
        }
    }
    //MARK:-Router
    func sendUserToNewUserVC(_ segue: UIStoryboardSegue, sender: Any?) {
        router.sendUserToNewUserVC(segue,sender: sender)
    }
    func openNewUserVC(sender: Any?) {
        router.openNewUserVC(sender: sender)
    }
}








