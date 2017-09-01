//
//  ShowCarsAssembly.swift
//  Auto-Application
//
//  Created by warSong on 9/1/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit

class ShowCarsAssembly {
    static let sharedInstance = ShowCarsAssembly()
    
    func buildNewUserModule(_ viewController: ShowCarsTableViewController) {
        let presenter = ShowCarsPresenter()
        let interactor = ShowCarsInteractor()
        let carDatabase = CarDatabaseManager()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.carDatabase = carDatabase
    }
}
