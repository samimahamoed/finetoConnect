//
//  Services.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 13/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth




class Services: NSObject {

    static private var srvUUIDS:[CBUUID:String] = [
        //custom 128 bit uuids
        
        CBUUID.init(string:"19581523-C3BB-41E1-BCF9-DCC98D1737C8"):"FINETO Power switch handle",
        CBUUID.init(string:"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"):"NordicSemiconductor UART",
        CBUUID.init(string:"00001908-0000-1000-8000-00805F9B34FB"):"NordicSemiconductor DFU",
        CBUUID.init(string:"00001909-0000-1002-8000-00805F9B34FB"):"Apple ANCS",
        
        //adopted 16 or 32 bit uuids
        CBUUID.init(string:"1811"):"Alert Notification Service",
        CBUUID.init(string:"1815"):"Automation IO",
        CBUUID.init(string:"180F"):"Battery Service",
        CBUUID.init(string:"1810"):"Blood Pressure",
        CBUUID.init(string:"1812"):"Human Interface Device",
        CBUUID.init(string:"181B"):"Body Composition",
        CBUUID.init(string:"181E"):"Bond Management Service",
        CBUUID.init(string:"181F"):"Continuous Glucose Monitoring",
        CBUUID.init(string:"1805"):"Current Time Service",
        CBUUID.init(string:"1818"):"Cycling Power",
        CBUUID.init(string:"1816"):"Cycling Speed and Cadence",
        CBUUID.init(string:"180A"):"Device Information",
        CBUUID.init(string:"1800"):"Generic Access",
        CBUUID.init(string:"1801"):"Generic Attribute",
        CBUUID.init(string:"1808"):"Glucose",
        CBUUID.init(string:"1809"):"Health Thermometer",
        CBUUID.init(string:"180D"):"Heart Rate",
        CBUUID.init(string:"1802"):"Immediate Alert",
        CBUUID.init(string:"1821"):"Indoor Positioning",
        CBUUID.init(string:"1803"):"Link Loss",
        CBUUID.init(string:"1819"):"Location and Navigation",
        CBUUID.init(string:"1807"):"Next DST Change Service",
        CBUUID.init(string:"180E"):"Phone Alert Status Service",
        CBUUID.init(string:"1822"):"Pulse Oximeter Service",
        CBUUID.init(string:"1806"):"Reference Time Update Service",
        CBUUID.init(string:"1814"):"Running Speed and Cadence",
        CBUUID.init(string:"1813"):"Scan Parameters",
        CBUUID.init(string:"1804"):"Tx Power",
        CBUUID.init(string:"181C"):"User Data",
        CBUUID.init(string:"181D"):"Weight Scale"
        
    
    ]
    
    
    
    static private var supportedSrvUUIDS:[CBUUID:String] = [
        
       CBUUID.init(string:"19581524-C3BB-41E1-BCF9-DCC98D1737C8"):"FINETO Power switch handle",

    ]
    
    
    static func getServiceName(uuid:CBUUID) -> String {
        if let name  = self.srvUUIDS[uuid] {
            return name
        }
        
        return Constants.MSGs.RESULT.UNKNOWN_Service
    }
    

    static func getServiceUISegue(uuid:CBUUID) -> String {
        if let name  = self.supportedSrvUUIDS[uuid] {
            return Constants.app.identifiers.defaultSegue + name.trimmingCharacters(in: .whitespaces)
        }
        
        return Constants.app.identifiers.defaultSegue
    }
    
    
    
    
    
    
}
