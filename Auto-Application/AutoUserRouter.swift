//
//  AutoUserRouter.swift
//  Auto-Application
//
//  Created by warSong on 8/28/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit
protocol AutoUserRouterInput: class {
    func sendUserToNewUserVC(_ segue: UIStoryboardSegue, sender: Any?)
    func openNewUserVC(sender: Any?)
}
class AutoUserRouter: AutoUserRouterInput {
    weak var view: AutoUsersViewController!
    struct Segues {
        static let newUserSegue = "newUserSegue"
    }
    func openNewUserVC(sender: Any?) {
        view.performSegue(withIdentifier: Segues.newUserSegue, sender: sender)
    }
    func sendUserToNewUserVC(_ segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.newUserSegue {
            if let destinationVC = segue.destination.contentViewController as? NewUserTableViewController {
                if let user = sender as? User {
                    destinationVC.presenter.fetchUserFromAutoUserVC(user)
                }
            }
        }
    }
}
