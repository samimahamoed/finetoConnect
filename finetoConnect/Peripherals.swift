//
//  Peripherals.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 06/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth

@objc class Peripherals: NSObject{

    var peripheral  : CBPeripheral
    var RSSI        : Int32
    var isConnected : Bool
    
    
    init(withPeripheral Peripheral: CBPeripheral, andRSSI RSSI:Int32, andIsConnected ConnectionStatus: Bool) {
        self.peripheral = Peripheral
        self.RSSI = RSSI
        self.isConnected = ConnectionStatus
        
        super.init()
    }
    
    
    func name()->String{
        let peripheralName = peripheral.name
        if peripheral.name == nil {
            return Constants.MSGs.SCAN_RESULT.UNKNOWN_DEVICE
        }else{
            return peripheralName!
        }
    }

//   func isEqual(object: AnyObject?) -> Bool {
//        if let other = object as? Peripherals {
//            return self.peripheral == other.peripheral
//        } else {
//            return false
//        }
//    }
//    override func isEqual(object: AnyObject?) -> Bool
//    
    
    override public func isEqual(_ object: Any?) -> Bool
    {
        let other : Peripherals = object as! Peripherals
        return peripheral == other.peripheral
    }
    
    
}



