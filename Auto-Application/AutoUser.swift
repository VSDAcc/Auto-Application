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
    var adress: String {get set}
}
class AutoUser: User {
    var name: String
    var userID: Int64
    var imageString: String
    var adress: String
    init(name: String, userID: Int64, imageString: String, adress: String) {
        self.name = name
        self.userID = userID
        self.imageString = imageString
        self.adress = adress
    }
    convenience init (name: String, imageString: String, adress: String) {
        self.init(name: name, userID: 0, imageString: imageString, adress: adress)
        self.name = name
        self.imageString = imageString
        self.adress = adress
    }
}
