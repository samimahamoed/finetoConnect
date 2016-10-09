//
//  appImages.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 08/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit

public class appImages: UIImage {

    
    public static func getImgConnectionStatus(isConnected:Bool) -> UIImage {
        
        return (isConnected ? UIImage(named: "Connected"): UIImage(named: "openConnection"))!
        
    }
    
    
    public static func getImgRSSIStatus(rssiValue: Int32) -> UIImage {
        
        var image: UIImage
        
        
        switch rssiValue {
        case let value where value < -90 :
            image = UIImage(named: "Signal_0")!
        case -90 ... -70 :
            image = UIImage(named: "Signal_1")!
        case -70 ... -50 :
            image = UIImage(named: "Signal_2")!
            
        case let value where value  > -50 :
            image = UIImage(named: "Signal_3")!
        
        default:
            image = UIImage(named: "Signal_0")!  //WTF?
        }
        
        return image
    }
    
    
    public static func getImgPeripheralCategory(deviceName: String) -> UIImage {
        //TODO try to use UUID instead
        
        var image: UIImage
        
        
        switch deviceName.lowercased() {
        case let name where name.range(of:"switch")    != nil:
            image = UIImage(named: "switch")!
        case let name where name.range(of: "doorlock") != nil:
            image = UIImage(named: "switch")!
       
        default:
            image = UIImage(named: "unknown")!  //WTF?
        }
        
        return image
    }

    
    
//    public func getImgPeripheralCategory(category: String) -> UIImage! {
//        
//        switch (category) {
////        case HMAccessoryCategoryTypeLightbulb:
////            return UIImage(named: "CategoryLightbulb")
////        case HMAccessoryCategoryTypeDoorLock:
////            return UIImage(named: "CategoryLock")
////        case HMAccessoryCategoryTypeGarageDoorOpener:
////            return UIImage(named: "CategoryGarageDoor")
////        case HMAccessoryCategoryTypeSwitch:
////            return UIImage(named: "CategorySwitch")
////        case HMAccessoryCategoryTypeOutlet:
////            return UIImage(named: "CategoryOutlet")
////        case HMAccessoryCategoryTypeFan:
////            return UIImage(named: "CategoryFan")
////            
////        case "0FBA259B-05AC-46F2-875F-204ABB6D9FE7":
////            return UIImage(named: "switch_off")
////            
////            
////            
//        
//            
//            
//        default: return UIImage(named: "CategoryNotSupported")
//        }
//    }
    
}
