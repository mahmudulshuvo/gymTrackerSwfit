//
//  UtilitySwift.swift
//  gymTracker
//
//  Created by Shuvo on 9/19/18.
//  Copyright © 2018 Third Bit. All rights reserved.
//

import Foundation

class Utility: NSObject {
    
    var documentDir: String = ""
    var databaseName: String = ""
    var databasePath: String = ""
    var settings = Settings()
    var dbDateFormat = DateFormatter()
    var userFriendlyDateFormat = DateFormatter()
    var dateOnlyDateFormat = DateFormatter()
    var noImage: UIImage!
    var checkBoxImage: UIImage!
    var checkBoxMarkedImage: UIImage!
    var equipmentsList: NSMutableArray = []
    var measurementsList: NSMutableArray = []
    
    class func showAlert(title: String, message: String, in vc: UIViewController) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

    static let sharedInstance:Utility = {
        let instance = Utility ()
        return instance
    } ()
    
    
    // MARK: Init
    override init() {
        dateOnlyDateFormat = DateFormatter()
        dateOnlyDateFormat.dateFormat = "dd"
        
        dbDateFormat = DateFormatter()
        dbDateFormat.dateFormat = "yyyy-MM-dd"
        
        userFriendlyDateFormat = DateFormatter()
        userFriendlyDateFormat.dateFormat = "MMM/dd/yyyy"
        
        noImage = UIImage(named: "no_image.jpg")
        
        checkBoxImage = UIImage(named: "checkBox.png")
        checkBoxMarkedImage = UIImage(named: "checkBoxMarked.png")
    }
    
    
//    static let sharedInstance: Utility = {
//        let sharedClient = Utility()
//
//        sharedClient.dateOnlyDateFormat = DateFormatter()
//        sharedClient.dateOnlyDateFormat.dateFormat = "dd"
//
//        sharedClient.dbDateFormat = DateFormatter()
//        sharedClient.dbDateFormat.dateFormat = "yyyy-MM-dd"
//
//        sharedClient.userFriendlyDateFormat = DateFormatter()
//        sharedClient.userFriendlyDateFormat.dateFormat = "MMM/dd/yyyy"
//
//        sharedClient.noImage = UIImage(named: "no_image.jpg")
//
//        sharedClient.checkBoxImage = UIImage(named: "checkBox.png")
//        sharedClient.checkBoxMarkedImage = UIImage(named: "checkBoxMarked.png")
//
//        return sharedClient
//    } ()
    
    class func scaleImage(image: UIImage, toSize newSize:CGSize) -> UIImage? {
        var width: Float = Float(newSize.width)
        var height: Float = Float(newSize.height)
        
        UIGraphicsBeginImageContext(newSize)
        var rect = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        
        let widthRatio: Float = Float(image.size.width) / width
        let heightRatio: Float = Float(image.size.height) / height
        let divisor: Float = widthRatio > heightRatio ? widthRatio : heightRatio
        
        width = Float(image.size.width) / divisor
        height = Float(image.size.height) / divisor
        
        rect.size.width = CGFloat(width)
        rect.size.height = CGFloat(height)
        
        let offset: Float = (width - height) / 2
        if offset > 0 {
            rect.origin.y = CGFloat(offset)
        } else {
            rect.origin.x = CGFloat(-offset)
        }
        
        image.draw(in: rect)
        
        let smallImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return smallImage
    }
    
    
     class func dateAtBeginningOfDay(inputDate: Date?) -> Date? {
        var calendar = Calendar.current
        let timeZone = NSTimeZone.system as NSTimeZone
        calendar.timeZone = timeZone as TimeZone
        
        var dateComps: DateComponents? = nil
        if let aDate = inputDate {
            //dateComps = calendar.dateComponents([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], from: aDate)
            dateComps = calendar.dateComponents([.year, .month, .day], from: aDate as Date)
        }
        
        dateComps?.hour = 0
        dateComps?.minute = 0
        dateComps?.second = 0
        
        var beginningOfDay: Date? = nil
        if let aComps = dateComps {
            beginningOfDay = calendar.date(from: aComps)
        }
        return beginningOfDay
    }
    
    
}
