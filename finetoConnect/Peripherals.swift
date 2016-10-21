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
    

    

    
    //MARK:- Peripheral Behavier
    
    func enableNotification(enable:Bool, characteristic:CBCharacteristic) -> Void {
        
        if(characteristic.properties.contains(CBCharacteristicProperties.notify) ||
            characteristic.properties.contains(CBCharacteristicProperties.indicate)
            ){
            self.peripheral.setNotifyValue(enable, for: characteristic)
        }
    }
    
    
    func writeCharacteristicValue(value:String, characteristic: CBCharacteristic, type: CBCharacteristicWriteType) -> Void {
        
        var strData:String = value.replacingOccurrences(of: "0x", with: "")
        let bytes          = [UInt8](strData.utf8)
        
        NSLog("writeCharacteristicValue %u", bytes)
        
        let data = Data(bytes:bytes)
        
        self.peripheral.writeValue(data, for: characteristic,type:type)
        
        
    }
    
    
    
    
    //MARK:- helpers
    
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
        
        switch length {
        case 1:
            return String(format: "0x%X",value.u8)
   
            
        case 2 :
 
            return String(format: "0x%X",UInt16(CFSwapInt16BigToHost(value.u16)))

        case 4 :
            
            return String(format: "0x%X",UInt32(CFSwapInt32BigToHost(value.u32)))
            
        case 8 :
            
            return String(format: "0x%X",UInt64(CFSwapInt64BigToHost(value.u64)))
      
        default:
            return value.rowDataToString()
        }
        
    
       
    }
    

    
    
    
    func canWriteValue(property:CBCharacteristicProperties) -> Bool {
      
        var canWrite:Bool = false
        
        if property.contains(CBCharacteristicProperties.writeWithoutResponse) {canWrite = true}
        
        if property.contains(CBCharacteristicProperties.write) {canWrite = true}

        if property.contains(CBCharacteristicProperties.authenticatedSignedWrites) {canWrite = true}
    
        return canWrite
    
    }
    
    
    func canReadValue(property:CBCharacteristicProperties) -> Bool {
        
        var canRead:Bool = false
        
        if property.contains(CBCharacteristicProperties.read) {canRead = true}
  
        return canRead
        
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



