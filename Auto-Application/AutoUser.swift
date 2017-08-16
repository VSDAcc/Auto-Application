//
//  AutoUser.swift
//  Auto-Application
//
//  Created by warSong on 8/15/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation
protocol User {
    var name: String {get set}
    var userID: Int64 {get set}
    var imageString: String {get set}
}
class AutoUser: User {
    var name: String
    var userID: Int64
    var imageString: String
    init(name: String, userID: Int64, imageString: String) {
        self.name = name
        self.userID = userID
        self.imageString = imageString
    }
}
