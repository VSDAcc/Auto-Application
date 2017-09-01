//
//  ShowCarsPresenter.swift
//  Auto-Application
//
//  Created by warSong on 9/1/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol ShowCarsPresenterInput: ShowCarsTableViewControllerOutput, ShowCarsInteractorOutput {
    
}
protocol ShowCarsPresenterOutput: ShowCarsTableViewControllerInput {
    
}
class ShowCarsPresenter: ShowCarsPresenterInput {
    
    weak var view: ShowCarsTableViewControllerInput!
    var interactor: ShowCarsInteractorInput!
    //MARK:-Interactor
    func queryAllCarsFromDatabase() {
        interactor.queryAllCarsFromDatabase()
    }
    func fetchUserAndUserCarsFromNewUserVC(user: User, userCars: [CarItem]) {
        interactor.fetchUserAndUserCarsFromNewUserVC(user: user, userCars: userCars)
    }
    //MARK:-View
    func didFetchAllCarsFromDatabase(userCars: [CarItem]) {
        view.didFetchAllCarsFromDatabase(userCars: userCars)
    }
    func didHandleErrorFromFetchingDatabase(error: String) {
        view.didHandleErrorFromFetchingDatabase(error: error)
    }
    func didHandleUserAndUserCarsFromNewUserVC(user: User, userCars: [CarItem]) {
        view.didHandleUserAndUserCarsFromNewUserVC(user: user, userCars: userCars)
    }
}
