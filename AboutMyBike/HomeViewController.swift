//
//  HomeViewController.swift
//  AboutMyBike
//
//  Created by James Donohue on 28/08/2017.
//  Copyright © 2017 James Donohue. All rights reserved.
//

import UIKit
import os.log

class HomeViewController: UIViewController {
    
    // MARK: Properties
    var bike: Bike?
    
    @IBOutlet weak var bikeImageView: UIImageView!
    @IBOutlet weak var bikeInfoLabel: UILabel!
    @IBOutlet weak var helpMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bike = loadBike()
        updateBikeInfo()
    }

    // MARK: Navigation
    
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? BikeViewController, let bike = sourceViewController.bike {
            self.bike = bike
            saveBike()
            updateBikeInfo()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let bikeViewController = segue.destination as? BikeViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        bikeViewController.bike = bike
    }
    
    // MARK: Private methods
    
    private func updateBikeInfo() {
        if let bike = bike {
            view.backgroundColor = UIColor.white
            helpMessageLabel.isHidden = true
            
            let label = createLabelString(bike: bike)
            bikeInfoLabel.attributedText = label
            
            bikeImageView.image = bike.photo
        } else {
            view.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    private func createLabelString(bike: Bike) -> NSAttributedString {
        let mutableLabel = NSMutableAttributedString(string: bike.make + "\n",
                                                     attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 24)])
        let addedString = NSAttributedString(string: bike.model + "\n\n",
                                             attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)])
        mutableLabel.append(addedString)
        
        if let vin = bike.vin {
            if !vin.isEmpty {
                mutableLabel.append(NSAttributedString(string: "VIN: " + vin + "\n",
                                                       attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)]))
            }
        }
        if let engineNo = bike.engineNo {
            if !engineNo.isEmpty {
                mutableLabel.append(NSAttributedString(string: "Engine no: " + engineNo,
                                                       attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)]))
            }
        }
        
        return mutableLabel
    }
    
    private func saveBike() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(bike!, toFile: Bike.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Bike successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save bike...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadBike() -> Bike? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Bike.ArchiveURL.path) as? Bike
    }
}
