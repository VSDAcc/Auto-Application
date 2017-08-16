//
//  AutoUsersTableViewCell.swift
//  Auto-Application
//
//  Created by warSong on 8/15/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit

class AutoUsersTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var autoUser: User! {
        didSet {
            updateUI()
        }
    }
    private func updateUI () {
        DispatchQueue.main.async {
            self.userAvatarImage.image = UIImage(named: self.autoUser.imageString)
            self.userNameLabel.text = self.autoUser.name
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.userAvatarImage.layer.cornerRadius = self.userAvatarImage.bounds.width / 2
        self.userAvatarImage.clipsToBounds = true
    }
}
