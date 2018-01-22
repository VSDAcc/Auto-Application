//
//  ShowCarsRouting.swift
//  Auto-Application
//
//  Created by warSong on 9/1/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation
protocol ShowCarsRouterInput: class {
    func backToNewUserVC(animated: Bool)
}
class ShowCarsRouter: ShowCarsRouterInput {
    weak var view: ShowCarsTableViewController!
    func backToNewUserVC(animated: Bool) {
        _ = view.navigationController?.popViewController(animated: animated)
    }
}
