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
    @objc optional func didConnectPeripheral(deviceName : String)
    @objc optional func didDisconnectPeripheral()
    @objc optional func peripheralReady()
    @objc optional func peripheralNotSupported()
    
}

class CentralManager: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    var bleManager                  : CBCentralManager?
    var delegate                    : centralManagerDelegate?
    var peripherals                 = [Peripherals]()
    
    
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
        
        
        DispatchQueue.main.async {
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
            
            delegate?.centralManagerDidUpdateBLEState(success: false, message:message)
            
            return
        }
        
        
       
        // peripherals = NSMutableArray(array: self.getConnectedPeripherals(filterUUID: nil))
         delegate?.centralManagerDidUpdateBLEState(success: true, message:message)
        
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        
        var peripheralDevice = Peripherals(withPeripheral: peripheral, andRSSI: RSSI.int32Value, andIsConnected: false)
        
        
        if !self.peripherals.contains(peripheralDevice)
        {
            self.peripherals.append(peripheralDevice)
        }
        else
        {
            peripheralDevice = self.peripherals[self.peripherals.index(of: peripheralDevice)!]
            peripheralDevice.RSSI = RSSI.int32Value
        }
        
      
        
    }
    
    
    func centralManager(_ central: CBCentralManager,didRetrieveConnectedPeripherals peripherals: [CBPeripheral])
    {
        
    }
    
    
    func centralManager(_ central: CBCentralManager,didRetrievePeripherals peripherals: [CBPeripheral])
    {
        
    }
    
    
    
    
    
    
    
    
    
}


class TheOneAndOnlyKraken {
    static let sharedInstance = TheOneAndOnlyKraken()
    private init() {} //This prevents others from using the default '()' initializer for this class.
}

