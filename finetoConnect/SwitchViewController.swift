//
//  SwitchViewController.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 21/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth
class SwitchViewController: UIViewController,centralManagerDelegate {

    

    private var messageView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    private var superView:UIView?
    
    var timer         :Timer?
    var activityTimer  = Timer()
  
    
    var primeryCharacteristic: CBCharacteristic?
    var switchStateCharacteristic:CBCharacteristic?
    
    var device:Switch?
    var centralManager:CentralManager?
    var service    : CBService? {
        didSet {
            
            centralManager                                   = CentralManager.singleToneInstance
            
            centralManager?.characteristicsViewDelegate      = self
            
            service?.peripheral.delegate                     = centralManager
            
            service?.peripheral.discoverCharacteristics(nil, for: service!)
            
            
        }
    }
    
   
   
    
    @IBOutlet var Connection: UIImageView!
    
    @IBOutlet var navBar: UINavigationItem!
    
    @IBOutlet var connectBtn: UIBarButtonItem!
    
    @IBOutlet weak var imgSwitchState: UIImageView!
    
    @IBOutlet weak var deviceName: UINavigationItem!
    
    @IBOutlet weak var btnSwitchState: UISegmentedControl!
    
    @IBAction func switchStateChangeEvent(_ sender: AnyObject){
        
 
        device?.dataRefresh()
        
        if (device?.isConnected)!{
            
            device?.writeToPowerState(service: self.service!, state: btnSwitchState.selectedSegmentIndex)
            
        }
        else
        {
            
            
            let alert = UIAlertController(title: "Error", message: "\(device?.name()) is not connected", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }

    
    
    
    @IBAction func connectBtnEvent(_ sender: AnyObject) {
        
        if (device?.isConnected)! {
            
            DispatchQueue.main.async {
                self.connectBtn.title = "Disconnecting ..."
                self.activityIndicator.startAnimating()
                
                if self.connectBtn.title == "Connect" {
                    NSLog("\(Constants.MSGs.ERROR_LOG.Conflict + self.description) connect, switchViewController ")
                }
            }
            
            self.centralManager?.bleManager?.cancelPeripheralConnection((device!.peripheral))
            
        }else{
            
            DispatchQueue.main.async {
                self.connectBtn.title = "Connecting ..."
                self.activityIndicator.startAnimating()
                
                if self.connectBtn.title == "Disconnect" {
                    
                    NSLog("\(Constants.MSGs.ERROR_LOG.Conflict + self.description) Disconnect, switchViewController ")
                }
                
            }
            
            self.centralManager?.bleManager?.connect((device!.peripheral), options: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView() {
        
        
        if let device = self.device{
  
            self.navBar.title = device.name()
            
            activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator.color = UIColor.darkGray
            activityIndicator.hidesWhenStopped = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: activityIndicator)
            
            
            
            self.timer = Timer.scheduledTimer(withTimeInterval: Double(Constants.app.UI_REFRESH_RATE),
                                              repeats: true,
                                              block: {_ in
                                                
                                                device.dataRefresh()
                                                device.readPowerState()
                                                
                                                if(device.peripheral != self.service?.peripheral ){
                                                    NSLog("MISMUCH")
                                                }
                                                
                                                if device.peripheral.state != CBPeripheralState.connected &&
                                                    device.peripheral.state != CBPeripheralState.disconnected
                                                {
                                                    return
                                                }
                                                
                                                self.Connection.image           = appImages.getImgConnectionStatus(isConnected: (device.isConnected))
                                                
                                                self.activityIndicator.stopAnimating()
                                                
                                                if (device.isConnected) {
                                                    self.connectBtn.title = "Disconnect"
                                                }else{
                                                    self.connectBtn.title = "Connect"
                                                }
                  
                }
            )
 
        }
    }
    
    
    //MARK: - CentralManagerDelegate
    func centralManagerDidUpdateBLEState(success: Bool, message:String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            if !success {
                alert.message = message
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    
    
    func didConnectPeripheral(peripheral: CBPeripheral)
    {
        NSLog("did connect, switchViewController ")
        
        if peripheral == device?.peripheral {
            
            DispatchQueue.main.async {
                if self.connectBtn.title == "Disconnect" ||  self.connectBtn.title == "Disconnecting ..." {
                    NSLog("\(Constants.MSGs.ERROR_LOG.Conflict + self.description) connect, switchViewController ")
                }
                
                self.connectBtn.title = "Disconnect"
                
                self.activityIndicator.stopAnimating()
            }
            
            device?.peripheral.discoverServices(device?.fiterUUIDs)
        }
        
    }
    
    
    
    func didDisconnectPeripheral(peripheral: CBPeripheral)
    {
        NSLog("did disconnect, switchViewController ")
        
        if peripheral == device?.peripheral {
            
            
            
            DispatchQueue.main.async {
                if self.connectBtn.title == "Connect" {
                    NSLog("\(Constants.MSGs.ERROR_LOG.Conflict + self.description) Disconnect, switchViewController ")
                }
                
                self.connectBtn.title = "Connect"
                self.activityIndicator.stopAnimating()
            
            }
            
        }
        
    }
    
    
    
    func didFailToConnect(peripheral: CBPeripheral, error: Error?)
    {
        
        if peripheral == device?.peripheral {
            
            let alert = UIAlertController(title: "Error", message:error as! String?, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
            self.connectBtn.title = "Connect"
            
        }
        
    }
    
    
    
    func didDiscoverServices(peripheral: CBPeripheral, error: Error?)
    {
        NSLog("didDiscoverServices, DetailViewController ")
        
        if peripheral == device?.peripheral {
            device?.peripheral.discoverCharacteristics(device?.fiterUUIDs, for: service!)
        }
        
    }
    
    
    func didDiscoverCharacteristics(peripheral: CBPeripheral,service:CBService, error: Error?)
    {
        NSLog("didDiscoverCharacteristics, SwitchViewController ")
        
        if peripheral == self.service?.peripheral && service == self.service {
            
            DispatchQueue.main.async {
                
                if(error==nil){
                         self.device?.didDiscoverCharacteristics(service:service)
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
            }
        }
        
    }
    
    
    
    func  didUpdateValueForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    {
        NSLog(" didUpdateValueForCharacteristic, SwitchViewController ")
        
        if peripheral == device?.peripheral {
         
            DispatchQueue.main.async {
            
                
                if(error==nil){
                        if characteristic.uuid.isEqual(self.device?.fiterUUIDs[1]){
                            self.btnSwitchState.selectedSegmentIndex = Int((characteristic.value?.u8)!)
                            
                        }
                    
                    return
                    
                }else{
                    
                    
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                   
                    return
                    
                }
                
            }
        }
        
        
    }
    
    func   didWriteValueForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    {
        NSLog(" didWriteValueForCharacteristic, SwitchViewController ")
        
        if peripheral == self.service?.peripheral {
            
            DispatchQueue.main.async {
                if(error==nil){
                      self.device?.readPowerState()
                    return
                    
                }else{
                    
                    
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    //TODO: Reattempt
                    return
                    
                }
                
            }
            
            
        }
        
    }
    
    
    
    
    
    
    
    

}
