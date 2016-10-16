//
//  DetailViewController.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 06/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth


class DetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, centralManagerDelegate {

 

    
    @IBOutlet var deviceName: UILabel!
    
    @IBOutlet var localNameLabel: UILabel!
    
    @IBOutlet var manufacturerDataLable: UILabel!
    
    @IBOutlet var serviceDataLable: UILabel!
    
    @IBOutlet var txPowerLable: UILabel!

    @IBOutlet var connectability: UILabel!
    
    @IBOutlet var connectOrnotBtn: UIButton!
    
    @IBOutlet var serviceListTableView: UITableView!
    
    @IBOutlet var emptyView: UIView!
    
    
    @IBOutlet var Connection: UIImageView!
    
    @IBOutlet var SignalStrength: UIImageView!
    

    var centralManager:CentralManager?
    
    var peripheral    : Peripherals? {
        didSet {
            centralManager                          = CentralManager.singleToneInstance
            
            centralManager?.detailViewDelegate      = self
            
            self.peripheral?.peripheral.delegate = centralManager
        }
    }
    
    var timer       :Timer?
    var colorMemo   :UIColor?
    
    
    
    
    @IBAction func connectOrnotBtnEvent(_ sender: UIButton) {
        
            if (self.peripheral?.isConnected)! {
                
                DispatchQueue.main.async {
                    self.connectOrnotBtn.setTitle("Disconnecting ...",for: .selected)
                    self.connectOrnotBtn.backgroundColor = UIColor.darkGray
                    
                    if self.connectOrnotBtn.currentTitle == "Connect" {
                        NSLog("\(Constants.MSGs.ERROR_LOG.Conflict + self.description) connect, DetailViewController ")
                    }   
                }
                
                self.centralManager?.bleManager?.cancelPeripheralConnection((self.peripheral?.peripheral)!)
                
            }else{
     
                DispatchQueue.main.async {
                    self.connectOrnotBtn.setTitle("Connecting ...",for: .selected)
                    self.connectOrnotBtn.backgroundColor = UIColor.darkGray
                    
                    if self.connectOrnotBtn.currentTitle == "Disconnect" {
                        
                        NSLog("\(Constants.MSGs.ERROR_LOG.Conflict + self.description) Disconnect, DetailViewController ")
                    }
   
               }
                
                self.centralManager?.bleManager?.connect((self.peripheral?.peripheral)!, options: nil)
            }

    }
    
    
    
    
    
    
    func configureView() {
  
        
        if let device = self.peripheral {
            
            self.peripheral?.dataRefresh()
            
          
            
            if let label = self.deviceName {
                label.text = device.name()
            }
            
            if let label = self.localNameLabel {
                
                if (device.adData?[CBAdvertisementDataLocalNameKey] as? String) != nil
                {
                    label.text = ": " + (device.adData?[CBAdvertisementDataLocalNameKey] as? String)!
                    
                }
                
                else
                {
                    label.text = ": N/A"
                }
               
                label.textAlignment = .left
            }
            
            if let label = self.manufacturerDataLable {

                if (device.adData?[CBAdvertisementDataManufacturerDataKey] as? String) != nil
                {
                    label.text = ": " + (device.adData?[CBAdvertisementDataManufacturerDataKey] as? String)!
                }
                    
                else
                {
                    label.text = ": N/A"
                }
                label.textAlignment = .left
                
            }
         
            if let label = self.serviceDataLable {
                if (device.adData?[CBAdvertisementDataServiceDataKey] as? String) != nil
                {
                    label.text = ": " + (device.adData?[CBAdvertisementDataServiceDataKey] as? String)!
                }
                    
                else
                {
                    label.text = ": N/A"
                }
                label.textAlignment = .left
            }
            
            if let label = self.txPowerLable {
                if (device.adData?[CBAdvertisementDataTxPowerLevelKey] as? String) != nil
                {
                    label.text = ": " + (device.adData?[CBAdvertisementDataTxPowerLevelKey] as? String)!
                }
                    
                else
                {
                    label.text = ": N/A"
                }
                label.textAlignment = .left
            }
            
            if let label = self.connectability {
                if (device.adData?[CBAdvertisementDataIsConnectable] as? String) != nil
                {
                    label.text = ": " + (device.adData?[CBAdvertisementDataIsConnectable] as? String)!
                }
                    
                else
                {
                    label.text = ": N/A"
                }
                label.textAlignment = .left
            }
            
            
            self.colorMemo = self.connectOrnotBtn.backgroundColor
            
            self.timer = Timer.scheduledTimer(withTimeInterval: Double(Constants.app.UI_REFRESH_RATE),
                                              repeats: true,
                                              block: {_ in 
                                                
                                                self.peripheral?.dataRefresh()
                                                
                                                
                                                    
                                                if self.peripheral?.peripheral.state != CBPeripheralState.connected &&
                                                   self.peripheral?.peripheral.state != CBPeripheralState.disconnected
                                                {
                                                    return
                                                }
                                                
                                                self.Connection.image           = appImages.getImgConnectionStatus(isConnected: (self.peripheral?.isConnected)!)
                                                
                                                self.SignalStrength.image       = appImages.getImgRSSIStatus(rssiValue: (self.peripheral?.RSSI)!)
                                                
                                                
                                                    if (self.peripheral?.isConnected)! {
                                                        self.connectOrnotBtn.setTitle("Disconnect",for: .normal)
                                                    }else{
                                                        self.connectOrnotBtn.setTitle("Connect",for: .normal)
                                                    }
                                                
                                                     self.connectOrnotBtn.backgroundColor = self.colorMemo
                
                                              }
            )
        
            
           
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.configureView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    
    
    
    
    
    
    
    // MARK:-  helpers
    func uiUpdateTimerEvent(){
        
        self.Connection.image     = appImages.getImgConnectionStatus(isConnected: (peripheral?.isConnected)!)
        
        self.SignalStrength.image       = appImages.getImgRSSIStatus(rssiValue: (peripheral?.RSSI)!)
        
    }
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.app.identifiers.defaultSegue {
            if let indexPath = self.serviceListTableView.indexPathForSelectedRow {
                let service = self.peripheral?.peripheral.services?[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! CharacteristicsViewController
                controller.service = service
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    
    //MARK: - CentralManagerDelegate
    func centralManagerDidUpdateBLEState(success: Bool, message:String) {
        
        let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        if !success {
            alert.message = message
            self.present(alert, animated: true, completion: nil)
            return
        }
     
    }
    
    
    func didConnectPeripheral(peripheral: CBPeripheral)
    {
        NSLog("did connect, DetailViewController ")
        
        if peripheral == self.peripheral?.peripheral {
            
             DispatchQueue.main.async {
                if self.connectOrnotBtn.currentTitle == "Disconnect" ||  self.connectOrnotBtn.currentTitle == "Disconnecting ..." {
                    NSLog("\(Constants.MSGs.ERROR_LOG.Conflict + self.description) connect, DetailViewController ")
                }
                
                self.connectOrnotBtn.setTitle("Disconnect",for: .normal)
            
                self.connectOrnotBtn.backgroundColor = self.colorMemo
                
             }
            
             self.peripheral?.peripheral.discoverServices(nil)
        }
        
    }
    
 
    
    func didDisconnectPeripheral(peripheral: CBPeripheral)
    {
         NSLog("did disconnect, DetailViewController ")
        
         if peripheral == self.peripheral?.peripheral {
            
            
            
            DispatchQueue.main.async {
                if self.connectOrnotBtn.currentTitle == "Connect" {
                    NSLog("\(Constants.MSGs.ERROR_LOG.Conflict + self.description) Disconnect, DetailViewController ")
                }
                
                self.connectOrnotBtn.setTitle("Connect",for: .normal)
                self.connectOrnotBtn.backgroundColor = self.colorMemo
                
                
                    self.serviceListTableView.reloadData()
            }
            
        }
        
    }
    
    
    
    func didFailToConnect(peripheral: CBPeripheral, error: Error?)
    {
        
        if peripheral == self.peripheral?.peripheral {
            
            let alert = UIAlertController(title: "Error", message:error as! String?, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    
            self.present(alert, animated: true, completion: nil)
         
            
            self.connectOrnotBtn.setTitle("Connect",for: .normal)
            
        }
        
    }
    
    
    
    func didDiscoverServices(peripheral: CBPeripheral, error: Error?)
    {
        NSLog("didDiscoverServices, DetailViewController ")
        
        if peripheral == self.peripheral?.peripheral {
            
            DispatchQueue.main.async {
                self.serviceListTableView.reloadData()
            }
        }
        
    }
    
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard (self.peripheral?.peripheral.services?.count) == nil
            
        else {
            if (self.peripheral?.peripheral.services?.count)! > 0
            {
                serviceListTableView.isHidden = false
                emptyView.isHidden  = true
                
            }
            else
            {
                serviceListTableView.isHidden = true
                emptyView.isHidden = false
                
            }
            return (self.peripheral?.peripheral.services?.count)!
        }
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.serviceListTableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! serviceTableViewCell
        

        if let service = (self.peripheral?.peripheral.services?[indexPath.row]) {
            
            cell.Name.text = Services.getServiceName(uuid:service.uuid)
            cell.Description.text = service.uuid.uuidString
            cell.type.image       = appImages.getPrimaryServiceTag(isPrimary: service.isPrimary)
            cell.Icon.image       = appImages.getImgServiceIcon(Name: Services.getServiceName(uuid:service.uuid))
            
        }
        
        return cell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.performSegue(withIdentifier: Services.getServiceUISegue(uuid: (self.peripheral?.peripheral.services?[indexPath.row].uuid)!)
            , sender: self)
        
    }
    
    
    

}

