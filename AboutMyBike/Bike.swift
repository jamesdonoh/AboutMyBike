//
//  Bike.swift
//  AboutMyBike
//
//  Created by James Donohue on 28/08/2017.
//  Copyright © 2017 James Donohue. All rights reserved.
//

import UIKit
import os.log

class Bike: NSObject, NSCoding {

    //MARK: Properties
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("bike")
    
    struct PropertyKey {
        static let make = "make"
        static let model = "model"
        static let vin = "vin"
        static let engineNo = "engineNo"
        static let photo = "photo"
    }
    
    var make: String
    var model: String
    
    var vin: String?
    var engineNo: String?
    
    var photo: UIImage?
    
    //MARK: Initialisation
    init?(make: String, model: String, vin: String?, engineNo: String?, photo: UIImage?) {
        // The make and model must not be empty
        guard !make.isEmpty && !model.isEmpty else {
            return nil
        }

        // Initialise stored properties
        self.make = make
        self.model = model
        self.vin = vin
        self.engineNo = engineNo
        
        self.photo = photo
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(make, forKey: PropertyKey.make)
        aCoder.encode(model, forKey: PropertyKey.model)
        aCoder.encode(vin, forKey: PropertyKey.vin)
        aCoder.encode(engineNo, forKey: PropertyKey.engineNo)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The make and model are required. If we cannot decode them the initializer should fail.
        guard let make = aDecoder.decodeObject(forKey: PropertyKey.make) as? String,
            let model = aDecoder.decodeObject(forKey: PropertyKey.model) as? String else {
            os_log("Unable to decode the make and model for a Bike object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because other properties are optional just use conditional cast.
        let vin = aDecoder.decodeObject(forKey: PropertyKey.vin) as? String
        let engineNo = aDecoder.decodeObject(forKey: PropertyKey.engineNo) as? String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        // Must call designated initializer.
        self.init(make: make, model: model, vin: vin, engineNo: engineNo, photo: photo)
    }
}
