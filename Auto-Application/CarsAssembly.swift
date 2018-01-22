//
//  CarsAssembly.swift
//  Auto-Application
//
//  Created by warSong on 9/1/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
class CarsAssembly {
    static let sharedInstance = CarsAssembly()
    func buildAutoUserModule(_ viewController: CarsViewController) {
        let presenter = CarsPresenter()
        let interactor = CarsInteractor()
        let carDatabase = CarDatabaseManager()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.carDatabase = carDatabase
    }
}
