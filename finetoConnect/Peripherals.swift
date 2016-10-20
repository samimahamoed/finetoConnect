//
//  Peripherals.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 06/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth

extension Data {
    var u8:UInt8 {
        assert(self.count >= 1)
        var byte:UInt8 = 0x00
        self.copyBytes(to: &byte, count: 1)
        return byte
    }
//    
//    var u16:UInt16 {
//        var array = UnsafeMutablePointer<UInt16>(u16)
//        assert(self.count >= 2)
//        var word:UnsafeMutablePointer<UInt16> = 0x0000
//        self.copyBytes(to: &word, count: 2)
//        return word
//    }
//    
//    var u32:UInt32 {
//        assert(self.count >= 4)
//        var u32:UInt32 = 0x00000000
//        self.copyBytes(to: &UInt8(u32), count: 4)
//        return u32
//    }
    
    var u8s:[UInt8] { // Array of UInt8, Swift byte array basically
        var buffer:[UInt8] = [UInt8](repeating: 0, count: self.count)
        self.copyBytes(to: &buffer, count: self.count)
        return buffer
    }
    
    var utf8:String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}


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
    

    
    override public func isEqual(_ object: Any?) -> Bool
    {
        let other : Peripherals = object as! Peripherals
        return peripheral == other.peripheral
    }
    
    
    func name()->String{
        if let peripheralName = peripheral.name {
            return peripheralName
        }else{
            return Constants.MSGs.RESULT.UNKNOWN_DEVICE
        }
    }
    
    
    func valueToString(value:Data) -> String {
        
        let length = value.count/MemoryLayout<UInt8>.size;
        
        //let data = characteristic.value
//        var array = UnsafeMutablePointer<UInt8>(nil)
//        
//        value.copyBytes(to: array, count: value.count)
        
        
        switch length {
        case 0...1:
            return String(format: "%X",value.u8)
   
            
        case 1...2 :
            return String(format: "%X",value.u8)

        case 2...4 :
            return String(format: "%X",value.u8)

            
        case 2...8 :
            return value.base64EncodedString()

            
            
        default:
            return value.base64EncodedString()
        }
        
    
       
    }
    
    func enableNotification(enable:Bool, characteristic:CBCharacteristic) -> Void {

        if(characteristic.properties.contains(CBCharacteristicProperties.notify) ||
           characteristic.properties.contains(CBCharacteristicProperties.indicate)
        ){
            self.peripheral.setNotifyValue(enable, for: characteristic)
         }
    }
    
    func canWriteValue(property:CBCharacteristicProperties) -> Bool {
      
        var canWrite:Bool = false
        
        if property.contains(CBCharacteristicProperties.writeWithoutResponse) {canWrite = true}
        
        if property.contains(CBCharacteristicProperties.write) {canWrite = true}

        if property.contains(CBCharacteristicProperties.authenticatedSignedWrites) {canWrite = true}
    
        return canWrite
    
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



