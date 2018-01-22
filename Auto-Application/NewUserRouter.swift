//
//  NewUserRouter.swift
//  Auto-Application
//
//  Created by warSong on 8/29/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit

protocol NewUserRouterInput: class {
    func sendUserToShowCarsVC(_ segue: UIStoryboardSegue, sender: Any?)
    func openShowCarsVC(sender: Any?)
    func backToAutoUserVC(animated: Bool)
}
class NewUserRouter: NewUserRouterInput {
    weak var view: NewUserTableViewController!
    struct Segues {
        static let showUsersCars = "ShowCars"
    }
    func openShowCarsVC(sender: Any?) {
        view.performSegue(withIdentifier: Segues.showUsersCars, sender: sender)
    }
    func backToAutoUserVC(animated: Bool) {
        _ = view.navigationController?.popViewController(animated: animated)
    }
    func sendUserToShowCarsVC(_ segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.showUsersCars {
            if let destinationVC = segue.destination.contentViewController as? ShowCarsTableViewController {
                if view.user != nil {
                destinationVC.presenter.didHandleUserAndUserCarsFromNewUserVC(user: view.user!, userCars: view.userCars)
                }
                destinationVC.presenter.newUserModuleInput = view.presenter
            }
        }
    }
}
