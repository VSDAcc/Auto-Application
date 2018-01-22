//
//  AutoUserAssembly.swift
//  Auto-Application
//
//  Created by warSong on 8/28/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit

class AutoUserAssembly {
    static let sharedInstance = AutoUserAssembly()
    func buildAutoUserModule(_ viewController: AutoUsersViewController) {
        let presenter = AutoUserPresenter()
        let interactor = AutoUserInteractor()
        let userDatabaseManager = UserDatabaseManager()
        let router = AutoUserRouter()
        viewController.presenter = presenter
        router.view = viewController
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.userDatabase = userDatabaseManager
    }
}
