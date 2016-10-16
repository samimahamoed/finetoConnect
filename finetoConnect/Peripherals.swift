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
    var adData      : [String : Any]?
    
    init(withPeripheral Peripheral: CBPeripheral, andRSSI RSSI:Int32, andIsConnected ConnectionStatus: Bool, adData: [String : Any]?) {
        self.peripheral = Peripheral
        self.RSSI = RSSI
        self.isConnected = ConnectionStatus
        
        guard adData != nil  else {
            self.adData = nil
            super.init()
            return
        }
        
        self.adData = adData
        
        super.init()
    }
    
    
    func name()->String{
      if let peripheralName = peripheral.name {
            return peripheralName
        }else{
            return Constants.MSGs.RESULT.UNKNOWN_DEVICE
        }
    }


    
    override public func isEqual(_ object: Any?) -> Bool
    {
        let other : Peripherals = object as! Peripherals
        return peripheral == other.peripheral
    }
    
    
    
    func dataRefresh() -> Void {
        
    
        
        switch peripheral.state {
        case CBPeripheralState.connected:
             self.isConnected = true
             peripheral.readRSSI()        
        case CBPeripheralState.disconnected:
             self.isConnected = false
          
        
        case CBPeripheralState.connecting:
             self.isConnected = false
        
        case CBPeripheralState.disconnecting:
             self.isConnected = false
 
        }
    }
    
    
}



