//
//  CarTableViewCell.swift
//  Auto-Application
//
//  Created by warSong on 8/17/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var carAvatarImage: UIImageView!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carlicensePlateLabel: UILabel!
    
    var car: CarItem! {
        didSet {
            updateUI()
        }
    }
    private func updateUI () {
        DispatchQueue.main.async {
            self.carAvatarImage.image = UIImage(named: self.car.carImage)
            self.carModelLabel.text = self.car.carModel
            self.carlicensePlateLabel.text = self.car.licensePlate
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.carAvatarImage.layer.cornerRadius = self.carAvatarImage.bounds.width / 2
        self.carAvatarImage.clipsToBounds = true
    }
}
