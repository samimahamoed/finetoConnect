//
//  CentralManager.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 06/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth


@objc protocol centralManagerDelegate {
    
    
    func centralManagerDidUpdateBLEState(success: Bool, message:String)
    @objc optional func centralManagerDidDiscoverPeripherals()
    @objc optional func didConnectPeripheral(peripheral: CBPeripheral)
    @objc optional func didDisconnectPeripheral(peripheral: CBPeripheral)
    @objc optional func didFailToConnect(peripheral: CBPeripheral,error: Error?)
    @objc optional func didDiscoverServices(peripheral: CBPeripheral,error: Error?)
    @objc optional func peripheralReady()
    @objc optional func peripheralNotSupported()
    
}

class CentralManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    
    var scannerDelegate              : centralManagerDelegate?
    var detailViewDelegate           : centralManagerDelegate?
    var characteristicsViewDelegate  : centralManagerDelegate?
    
    
    var bleManager                   : CBCentralManager?
    var peripherals                  = [Peripherals]()
    var _peripheral                  : CBPeripheral?
    
    
    static let singleToneInstance = CentralManager()
    
    private override init() {
    
        super.init()
        
        let serialQueue = DispatchQueue.init(label: Constants.queues.bleCentralManagerSerialQueue)
        bleManager = CBCentralManager(delegate: self, queue: serialQueue)
        
    }
    
    
    // MARK:-  helpers
  
    
    
    func scanForPeripherals(enable:Bool, filterUUID:CBUUID?) -> (Bool, String) {
        
        var message:String  = Constants.MSGs.CENTRAL_MANAGER_STATE.poweredOn
        
        guard bleManager?.state == CBManagerState.poweredOn
            else
        {
            
            
            switch (bleManager?.state)! {
            case .unknown:
                  message = Constants.MSGs.CENTRAL_MANAGER_STATE.unknown
            case .resetting:
                  message = Constants.MSGs.CENTRAL_MANAGER_STATE.resetting
            case .unsupported:
                  message = Constants.MSGs.CENTRAL_MANAGER_STATE.unsupported
            case .unauthorized:
                  message = Constants.MSGs.CENTRAL_MANAGER_STATE.unauthorized
            default:
                  message = Constants.MSGs.CENTRAL_MANAGER_STATE.unknown
            }
            
            
            
            NSLog("%s", message)
            
            return (false,message)
        }
        
        
     
            if enable == true {
                let options: NSDictionary = NSDictionary(objects: [NSNumber(value: true)], forKeys: [CBCentralManagerScanOptionAllowDuplicatesKey as NSCopying])
                if filterUUID != nil {
                    self.bleManager?.scanForPeripherals(withServices: [filterUUID!], options: options as? [String : AnyObject])
                } else {
                    self.bleManager?.scanForPeripherals(withServices: nil, options: options as? [String : AnyObject])
                }
                
        
            } else {
             
                self.bleManager?.stopScan()
            }
       
        
        return (true,message)
    }
 
    
    func getConnectedPeripherals(filterUUID:CBUUID?) -> NSArray {
        var retreivedPeripherals : NSArray?
        
        if filterUUID != nil {
            
            retreivedPeripherals     = (bleManager?.retrieveConnectedPeripherals(withServices: [filterUUID!]))! as NSArray
        }
        
        return retreivedPeripherals!
    }
    
    
    //MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager)  {
        
        var message:String  = Constants.MSGs.CENTRAL_MANAGER_STATE.poweredOn
        
        guard central.state == CBManagerState.poweredOn
            else
        {
            
            switch central.state {
            case .unknown:
                message = Constants.MSGs.CENTRAL_MANAGER_STATE.unknown
            case .resetting:
                message = Constants.MSGs.CENTRAL_MANAGER_STATE.resetting
            case .unsupported:
                message = Constants.MSGs.CENTRAL_MANAGER_STATE.unsupported
            case .unauthorized:
                message = Constants.MSGs.CENTRAL_MANAGER_STATE.unauthorized
            default:
                message = Constants.MSGs.CENTRAL_MANAGER_STATE.unknown
            }
   
            
            NSLog("%s", message)
            
            scannerDelegate?.centralManagerDidUpdateBLEState(success: false, message:message)
            
            return
        }
        
        
       
        // peripherals = NSMutableArray(array: self.getConnectedPeripherals(filterUUID: nil))
         scannerDelegate?.centralManagerDidUpdateBLEState(success: true, message:message)
        
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        
        var peripheralDevice = Peripherals(withPeripheral: peripheral,
                                           andRSSI: RSSI.int32Value,
                                           andIsConnected: false,
                                           adData: advertisementData
                                          )
        
        
        if !self.peripherals.contains(peripheralDevice)
        {
            self.peripherals.append(peripheralDevice)
        }
        else
        {
            peripheralDevice = self.peripherals[self.peripherals.index(of: peripheralDevice)!]
            peripheralDevice.RSSI = RSSI.int32Value
        }
        
        scannerDelegate?.centralManagerDidDiscoverPeripherals!()
                
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

         detailViewDelegate?.didConnectPeripheral!(peripheral: peripheral)
        
        
        
        
        
       //  peripheral.discoverServices(nil)
    }
    
    
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard error == nil else {
            NSLog("CentralManager did disconnect peripheral \(error)")
            return
        }
   
        detailViewDelegate?.didDisconnectPeripheral!(peripheral: peripheral)
       
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard error == nil else {
            NSLog("CentralManager did didFailToConnect peripheral \(error)")
            return
        }
        
        detailViewDelegate?.didFailToConnect!(peripheral: peripheral,error: error)
   
    }
    
    //MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            NSLog("CentralManager did didDiscoverServices \(error)")
            return
        }
        
        detailViewDelegate?.didDiscoverServices!(peripheral: peripheral,error: error)
    }
    
//    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
//        guard error == nil else {
//            log(withLevel: .WarningLogLevel, andMessage: "Characteristics discovery failed")
//            logError(error: error!)
//            return
//        }
//        log(withLevel: .InfoLogLevel, andMessage: "Characteristics discovererd")
//        
//        if service.UUID.isEqual(UARTServiceUUID) {
//            for aCharacteristic : CBCharacteristic in service.characteristics! {
//                if aCharacteristic.UUID.isEqual(UARTTXCharacteristicUUID) {
//                    log(withLevel: .VerboseLogLevel, andMessage: "TX Characteristic found")
//                    uartTXCharacteristic = aCharacteristic
//                }else if aCharacteristic.UUID.isEqual(UARTRXCharacteristicUUID) {
//                    log(withLevel: .VerboseLogLevel, andMessage: "RX Characteristic found")
//                    uartRXCharacteristic = aCharacteristic
//                }
//            }
//            //Enable notifications on TX Characteristic
//            if(uartTXCharacteristic != nil && uartRXCharacteristic != nil) {
//                log(withLevel: .VerboseLogLevel, andMessage: "Enableg notifications for \(uartTXCharacteristic?.UUID.UUIDString)")
//                log(withLevel: .DebugLogLevel, andMessage: "peripheral.setNotifyValue(true, forCharacteristic: \(uartTXCharacteristic?.UUID.UUIDString)")
//                bluetoothPeripheral?.setNotifyValue(true, forCharacteristic: uartTXCharacteristic!)
//            }else{
//                log(withLevel: .WarningLogLevel, andMessage: "UART service does not have required characteristics. Try to turn Bluetooth OFF and ON again to clear cache.")
//                delegate?.peripheralNotSupported()
//                cancelPeriphralConnection()
//            }
//        }
//        
//    }
//    
//    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
//        guard error == nil else {
//            log(withLevel: .WarningLogLevel, andMessage: "Enabling notifications failed")
//            logError(error: error!)
//            return
//        }
//        
//        if characteristic.isNotifying {
//            log(withLevel: .InfoLogLevel, andMessage: "Notifications enabled for characteristic : \(characteristic.UUID.UUIDString)")
//        }else{
//            log(withLevel: .InfoLogLevel, andMessage: "Notifications disabled for characteristic : \(characteristic.UUID.UUIDString)")
//        }
//        
//    }
//    
//    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
//        guard error == nil else {
//            log(withLevel: .WarningLogLevel, andMessage: "Writing value to characteristic has failed")
//            logError(error: error!)
//            return
//        }
//        log(withLevel: .InfoLogLevel, andMessage: "Data written to characteristic: \(characteristic.UUID.UUIDString)")
//    }
//    
//    func peripheral(peripheral: CBPeripheral, didWriteValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
//        guard error == nil else {
//            log(withLevel: .WarningLogLevel, andMessage: "Writing value to descriptor has failed")
//            logError(error: error!)
//            return
//        }
//        log(withLevel: .InfoLogLevel, andMessage: "Data written to descriptor: \(descriptor.UUID.UUIDString)")
//    }
//    
//    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
//        guard error == nil else {
//            log(withLevel: .WarningLogLevel, andMessage: "Updating characteristic has failed")
//            logError(error: error!)
//            return
//        }
//        log(withLevel: .InfoLogLevel, andMessage: "Notification received from: \(characteristic.UUID.UUIDString), with value: \(characteristic.value)")
//        log(withLevel: .AppLogLevel, andMessage: "\(characteristic.value) received")
//    }
//    
//    
//    func centralManager(_ central: CBCentralManager,didRetrieveConnectedPeripherals peripherals: [CBPeripheral])
//    {
//        
//    }
//    
//    
//    func centralManager(_ central: CBCentralManager,didRetrievePeripherals peripherals: [CBPeripheral])
//    {
//        
//    }
//    
    
    
    
    
    
    
    
    
}


