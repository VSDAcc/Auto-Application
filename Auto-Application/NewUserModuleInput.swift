//
//  NewUserModuleInput.swift
//  Auto-Application
//
//  Created by warSong on 8/31/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation

protocol NewUserModuleInput: class {
    func didFetchUserCars(_ userCars: [CarItem])
}
