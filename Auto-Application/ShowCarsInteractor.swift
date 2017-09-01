//
//  ShowCarsInteractor.swift
//  Auto-Application
//
//  Created by warSong on 9/1/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation
protocol ShowCarsInteractorInput: class {
    func queryAllCarsFromDatabase()
    func fetchUserAndUserCarsFromNewUserVC(user: User, userCars: [CarItem])
}
protocol ShowCarsInteractorOutput: class {
    func didFetchAllCarsFromDatabase(userCars: [CarItem])
    func didHandleErrorFromFetchingDatabase(error: String)
    func didHandleUserAndUserCarsFromNewUserVC(user: User, userCars: [CarItem])
}
class ShowCarsInteractor: ShowCarsInteractorInput {
    
    var carDatabase: CarsDatabaseHandler?
    weak var presenter: ShowCarsPresenterInput!
    //MARK:-Routing
    func fetchUserAndUserCarsFromNewUserVC(user: User, userCars: [CarItem]) {
        presenter.didHandleUserAndUserCarsFromNewUserVC(user: user, userCars: userCars)
    }
    //MARK:-CarDatabase
    func queryAllCarsFromDatabase() {
        carDatabase?.queryAllCars(onSucces: { [unowned self](carsArray) in
            self.presenter.didFetchAllCarsFromDatabase(userCars: carsArray)
        }, onFailure: { [unowned self] (error) in
            self.presenter.didHandleErrorFromFetchingDatabase(error: error)
        })
    }
}
