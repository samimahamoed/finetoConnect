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
            image = UIImage(named: "doorlock")!
       
        default:
            image = UIImage(named: "unknown")!  //WTF?
        }
        
        return image
    }

    public static func getPrimaryServiceTag(isPrimary:Bool) -> UIImage {
   
        if isPrimary {
            return UIImage(named: "primary_service")!
        }
            return UIImage(named: "unknown")!
        
    }
    
    
    public static func getImgServiceIcon(Name: String) -> UIImage {
        //TODO try to use UUID instead
        
        var image: UIImage
        
        
        switch Name.lowercased() {
        case let name where name.range(of:"switch")    != nil:
            image = UIImage(named: "switch")!
        case let name where name.range(of: "doorlock") != nil:
            image = UIImage(named: "doorlock")!
            
        default:
            image = UIImage(named: "unknown")!  
        }
        
        return image
    }
    
}
