//
//  Switch.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 21/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth
class Switch: Peripherals {
    
    
    var primeryCharacteristic: CBCharacteristic?
    var switchPowerStateCharacteristicRead:CBCharacteristic?
    var switchPowerStateCharacteristicWrite:CBCharacteristic?
    
    var fiterUUIDs = [CBUUID]()
    
    
      init(withPeripheral peripheral: Peripherals) {
        if let uuid = Services.getServiceUUID(serviceName: "FINETO Power switch handle"){self.fiterUUIDs.append(uuid)}
        if let uuid = Characteristics.getCharacteristicsUUID(characteristicName: "FINETO Power switch read"){self.fiterUUIDs.append(uuid)}
        if let uuid = Characteristics.getCharacteristicsUUID(characteristicName: "FINETO Power switch write"){self.fiterUUIDs.append(uuid)}
        
        super.init(withPeripheral: peripheral.peripheral,
                   andRSSI: peripheral.RSSI,
                   andIsConnected: peripheral.isConnected,
                   adData: peripheral.adData)
       
   
        
     }
    
    
    func writeToPowerState(service:CBService,state:Int) -> Void{
        
     
         var bytes: [UInt8] = []
        
         bytes.append(UInt8(state))
        
         let data = Data(bytes:bytes)
        
         if switchPowerStateCharacteristicWrite != nil{
            self.peripheral.writeValue(data, for: switchPowerStateCharacteristicWrite!,type:CBCharacteristicWriteType.withResponse)
         }else{
            for characteristic : CBCharacteristic in service.characteristics! {
                if characteristic.uuid.isEqual(self.fiterUUIDs[2]){
                    NSLog(characteristic.uuid.uuidString)
                    self.switchPowerStateCharacteristicWrite = characteristic
                }
                
                
                
            }
            if switchPowerStateCharacteristicWrite != nil{
                self.peripheral.writeValue(data, for: switchPowerStateCharacteristicWrite!,type:CBCharacteristicWriteType.withResponse)
            }
            else{
               NSLog("writeToPowerState, Switch "+Constants.MSGs.ERROR_LOG.FatalError)
            }
        }
        
    }
    func readPowerState() -> Void{
        
         if switchPowerStateCharacteristicRead != nil{
            peripheral.readValue(for: switchPowerStateCharacteristicRead!)
         }
    }
    
    
    func didDiscoverCharacteristics(service:CBService)
    {
        for characteristic : CBCharacteristic in service.characteristics! {
        
            if characteristic.uuid.isEqual(self.fiterUUIDs[2]){
                self.switchPowerStateCharacteristicWrite = characteristic
             //   peripheral.setNotifyValue(true, for: characteristic)
            }
            
            if characteristic.uuid.isEqual(self.fiterUUIDs[1]){
                NSLog(characteristic.uuid.uuidString)
                self.switchPowerStateCharacteristicRead = characteristic
                //peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
        
}
    
    

