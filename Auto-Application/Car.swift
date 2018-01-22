//
//  Car.swift
//  Auto-Application
//
//  Created by warSong on 8/17/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import Foundation
protocol CarItem {
    var carModel: String {get set}
    var carImage: String {get set}
    var carID: Int64 {get set}
    var licensePlate: String {get set}
    var userID: Int64 {get set}
}
class Car: CarItem {
    var carModel: String
    var carImage: String
    var carID: Int64
    var licensePlate: String
    var userID: Int64
    init(carModel: String, carImage: String, carID: Int64, licensePlate: String, userID: Int64) {
        self.carModel = carModel
        self.carImage = carImage
        self.carID = carID
        self.licensePlate = licensePlate
        self.userID  = userID
    }
    convenience init (carModel: String, carImage: String, licensePlate: String, userID: Int64) {
        self.init(carModel: carModel, carImage: carImage, carID: 0, licensePlate: licensePlate, userID: userID)
    }
}
