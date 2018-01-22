//
//  AlertMethods.swift
//  Auto-Application
//
//  Created by warSong on 8/16/17.
//  Copyright © 2017 VLadymyrShorokhov. All rights reserved.
//

import UIKit

protocol PresenterAlertHandler {
    func presentAlertWith(title: String, massage: String)
}
extension PresenterAlertHandler where Self: UIViewController {
    func presentAlertWith(title: String, massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
}
