//
//  CarsPresenter.swift
//  Auto-Application
//
//  Created by warSong on 9/1/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol CarsPresenterInput: CarsViewControllerOutput, CarsInteractorOutput {
    
}
protocol CarsPresenterOutput: CarsViewControllerInput {
    
}
class CarsPresenter: CarsPresenterInput {
    weak var view: CarsViewControllerInput!
    var interactor: CarsInteractorInput!
    //MARK:-Interactor
    func queryAllCarsFromDatabase() {
        interactor.queryAllCarsFromDatabase()
    }
    func addMoreCarsToDatabase() {
        interactor.addMoreCarsToDatabase()
    }
    func deleteCarFromDatabase(carID: Int64) {
        interactor.deleteCarFromDatabase(carID: carID)
    }
    //MARK:-View
    func didFetchAllCarsFromDatabase(userCars: [CarItem]) {
        view.didFetchAllCarsFromDatabase(userCars: userCars)
    }
    func didHandleErrorFromFetchingDatabase(error: String) {
        view.didHandleErrorFromFetchingDatabase(error: error)
    }
}
