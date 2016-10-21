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
    @objc optional func didDiscoverCharacteristics(peripheral: CBPeripheral,error: Error?)
    @objc optional func didUpdateNotificationStateForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    @objc optional func didUpdateValueForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    @objc optional func didWriteValueForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    @objc optional func peripheralReady()
    @objc optional func peripheralNotSupported()
    
}

class CentralManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    
  
    var scannerDelegate              : centralManagerDelegate?
    var detailViewDelegate           : centralManagerDelegate?
    var characteristicsViewDelegate  : centralManagerDelegate?
    
    
    var bleManager                   : CBCentralManager?
    var peripherals                  = [Peripherals]()
   
    
    
    
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
    
    func centralManager(_ central: CBCentralManager,didRetrieveConnectedPeripherals peripherals: [CBPeripheral])
    {
    
    }
    
    
    func centralManager(_ central: CBCentralManager,didRetrievePeripherals peripherals: [CBPeripheral])
    {
            
    }
    
    
    
    //MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            NSLog("CentralManager did didDiscoverServices \(error)")
            
            return
        }
        
        detailViewDelegate?.didDiscoverServices!(peripheral: peripheral,error: error)
        
        
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            NSLog("CentralManager did didDiscoverCharacteristicsForService \(error)")
            characteristicsViewDelegate?.didDiscoverCharacteristics!(peripheral: peripheral, error: error)
            
            return
        }
        
        characteristicsViewDelegate?.didDiscoverCharacteristics!(peripheral: peripheral, error:error)
    
    }
  

    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            NSLog("CentralManager didUpdateNotificationStateForCharacteristic \(error)")
            characteristicsViewDelegate?.didDiscoverCharacteristics!(peripheral: peripheral, error: error)
            return
        }
        
        characteristicsViewDelegate?.didUpdateNotificationStateForCharacteristic!(peripheral: peripheral,
                                                                                 characteristic: characteristic,
                                                                                 error: error)
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            NSLog("CentralManager didUpdateNotificationStateForCharacteristic \(error)")
            characteristicsViewDelegate?.didDiscoverCharacteristics!(peripheral: peripheral, error: error)
            return
        }
        
        characteristicsViewDelegate?.didUpdateValueForCharacteristic!(peripheral: peripheral,
                                                                                  characteristic: characteristic,
                                                                                  error: error)
    
    }
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            NSLog("CentralManager didWriteValueForCharacteristic \(error)")
            characteristicsViewDelegate?.didWriteValueForCharacteristic!(peripheral: peripheral,
                                                                         characteristic: characteristic,
                                                                         error: error)
            return
        }
        
        characteristicsViewDelegate?.didWriteValueForCharacteristic!(peripheral: peripheral,
                                                                      characteristic: characteristic,
                                                                      error: error)
    }
    
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

//    
//
//    
    
    
    
    
    
    
    
    
}


