//
//  NewUserAssembly.swift
//  Auto-Application
//
//  Created by warSong on 9/1/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit

class NewUserAssembly {
    static let sharedInstance = NewUserAssembly()
    
    func buildNewUserModule(_ viewController: NewUserTableViewController) {
        let presenter = NewUserPresenter()
        let interactor = NewUserInteractor()
        let carDatabase = CarDatabaseManager()
        let userDatabase = UserDatabaseManager()
        let router = NewUserRouter()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.carDatabase = carDatabase
        interactor.userDatabase = userDatabase
        router.view = viewController
    }
}
