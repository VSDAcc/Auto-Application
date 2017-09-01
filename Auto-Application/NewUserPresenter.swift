//
//  NewUserPresenter.swift
//  Auto-Application
//
//  Created by warSong on 8/29/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol NewUserPresenterInput: NewUserTableViewControllerOutput, NewUserInteractorOutput {
    
}
protocol NewUserPresenterOutput: NewUserTableViewControllerInput {
    
}
class NewUserPresenter: NewUserPresenterInput {
    
    weak var view: NewUserTableViewControllerInput!
    var interactor: NewUserInteractorInput!
    var router: NewUserRouterInput!
    //MARK:-Interactor
    func queryAllUserCarsFromDatabase(userID: Int64) {
        interactor.queryAllUserCarsFromDatabase(userID: userID)
    }
    func saveNewUserToDatabase(newUser: User, userCars: [CarItem]) {
        interactor.saveNewUserToDatabase(newUser: newUser, userCars: userCars)
    }
    func updateUserToDatabase(userID: Int64, newUser: User, userCars: [CarItem]) {
        interactor.updateUserToDatabase(userID: userID, newUser: newUser, userCars: userCars)
    }
    func updateUserCarToDatabase(carID: Int64, newCar: CarItem) {
        interactor.updateUserCarToDatabase(carID: carID, newCar: newCar)
    }
    func fetchUserFromAutoUserVC(_ user: User) {
        interactor.saveUserFromAutoUserVC(user)
    }
    //MARK:-View
    func didFetchUserCarFromDatabase(userCar: CarItem) {
        view.didFetchUserCarFromDatabase(userCar: userCar)
    }
    func didHandleErrorFromFetchingDatabase(error: String) {
        view.didHandleErrorFromFetchingDatabase(error: error)
    }
    func didFetchUserFromAutoUserVC(_ user: User) {
        view.didFetchUserFromAutoUserVC(user)
    }
    //MARK:-Router
    func sendUserToShowCarsVC(_ segue: UIStoryboardSegue, sender: Any?) {
        router.sendUserToShowCarsVC(segue, sender: sender)
    }
    func openShowCarsVC(sender: Any?) {
        router.openShowCarsVC(sender: sender)
    }
}
