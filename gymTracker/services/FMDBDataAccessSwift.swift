//
//  FMDBDataAccessSwift.swift
//  gymTracker
//
//  Created by Shuvo on 9/23/18.
//  Copyright © 2018 Third Bit. All rights reserved.
//

import Foundation

class FMDBDataAccessSwift: NSObject {
    
    
    static let utility = Utility.sharedInstance
    
    class func getEquipments() -> NSMutableArray {
        let equipments: NSMutableArray = []
        
        let db = FMDatabase(path: utility.databasePath)
        
        db?.open()
        
        let results: FMResultSet? = db?.executeQuery("SELECT * FROM equipment order by equipment_name ASC",  withArgumentsIn: [])
        
        while results?.next() ?? false {
            let equipment = Equipment()
            equipment.id = results?.int(forColumn: "id") as NSNumber?
            equipment.equipmentName = results?.string(forColumn: "equipment_name")
            equipment.imageName = results?.string(forColumn: "image_name")
            equipment.measurementId = results?.int(forColumn: "measurement_id") as NSNumber?
            
            equipments.add(equipment)
           // equipments.append(equipment)
        }
        
        db?.close()
        
        return equipments
    }
    
    class func createEquipment(_ equipment: Equipment?) -> Bool {
        let db = FMDatabase(path: utility.databasePath)
        

        db?.open()
        
        //let success = try db?.executeUpdate("INSERT INTO equipment where equipment_name = ? image_name=? measurement_id=?", values:[equipment?.equipmentName, equipment?.imageName, String(format:"%d", equipment?.measurementId)])
        //let success = db?.executeUpdate("INSERT INTO equipment (equipment_name, image_name, measurement_id) VALUES (?, ?, ?);" withParameterDictionary: ["equipment_name": equipment?.equipmentName,  "image_name":equipment?.imageName, "measurement_id": equipment?.measurementId])
        //let success: Bool  = db?.executeUpdate("INSERT INTO equipment (equipment_name, image_name, measurement_id) VALUES (?, ?, ?);", withArgumentsIn: nil) ?? false
            
            
        
       // let success: Bool = db?.executeUpdate("INSERT INTO equipment (equipment_name, image_name, measurement_id) VALUES (?, ?, ?);", equipment?.equipmentName, equipment?.imageName,
        //    equipment?.measurementId.description)
        
        db?.close()
        return success
    }
    
    
    
    class func getSettings() -> Settings {
        
        let db = FMDatabase.init(path: utility.databasePath)
        
        db?.open()
        let results = db?.executeQuery("SELECT * FROM settings", withArgumentsIn: [])
        var settings: Settings!
        
        while results?.next() ?? false {
            settings = Settings()
        
            settings?.id = results?.int(forColumn: "id") as NSNumber?
            settings?.weight = results?.string(forColumn: "weight")
            settings?.sets = results?.int(forColumn: "sets")as NSNumber?
            settings?.measurement = results?.string(forColumn: "measurement")
        }
        
        db?.close()
        
        return settings
    }
    
}
