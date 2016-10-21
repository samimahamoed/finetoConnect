//
//  MasterViewController.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 06/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth

struct flagsType {
    var scanning:Bool = false
    var viewAll :Bool = true
}


class MasterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,centralManagerDelegate{
    
    
    
    
    @IBOutlet var peripheralsTableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var scanOrnotBtn: UIBarButtonItem!
    @IBOutlet var busyScannig: UIActivityIndicatorView!
    @IBOutlet var viewAll: UIBarButtonItem!
    @IBOutlet var viewOnlyConnected: UIBarButtonItem!

    
    
    
    var detailViewController: DetailViewController? = nil
    
    var centralManager              : CentralManager?
    var timer                       : Timer?

    
  
    var flags                       = flagsType(scanning: false, viewAll:true)
    
    
    
    
    @IBAction func scanORnotEvent(_ sender: AnyObject) {
        if flags.scanning
        {
            scanningState(active:false)
        }
        else
        {
            scanningState(active: true)
        }
        
    }
    
    
    @IBAction func viewAllEvent(_ sender: AnyObject) {
        flags.viewAll = true
        viewAll.tintColor = UIColor.blue
        viewOnlyConnected.tintColor = UIColor.black
        
    }
    
    
    @IBAction func viewOnlyConnectedEvent(_ sender: AnyObject) {
        flags.viewAll = false
        viewAll.tintColor = UIColor.black
        viewOnlyConnected.tintColor = UIColor.blue
        
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager                          = CentralManager.singleToneInstance
        centralManager?.scannerDelegate          = self
        busyScannig.hidesWhenStopped            = true
        busyScannig.startAnimating()
       
        
        if let split = self.splitViewController {
            
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        flags.viewAll = true
        viewAll.tintColor = UIColor.blue
        viewOnlyConnected.tintColor = UIColor.black    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        peripheralsTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    // MARK:-  helpers
    func scanTimerEvent(){
            scanningState(active:false)
    }
    

    func scanningState(active:Bool){
        
        
        let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        if active {
            busyScannig.startAnimating()
            flags.scanning = true
            scanOrnotBtn.title = "Cancel"
            
            let (success,message) = (centralManager?.scanForPeripherals(enable: true,filterUUID: nil))!
            
            if !success {
                alert.message = message
                self.present(alert, animated: true, completion: nil)
                return
            }
            
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: Double(
                                              Constants.app.PERIPHERAL_SCAN_TIMEOUT_PERIOD),
                                              target: self,
                                              selector: #selector(self.scanTimerEvent),
                                              userInfo: nil,
                                              repeats: false)
               }
            
            return
        }
        
        
            timer?.invalidate()
            timer = nil
            busyScannig.stopAnimating()
            flags.scanning = false
            scanOrnotBtn.title = "Scan"
        
            let (success, message)  = (centralManager?.scanForPeripherals(enable: false, filterUUID: nil))!
                
            if !success {
                alert.message = message
                self.present(alert, animated: true, completion: nil)
            }
        
    }
    
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
                        if let indexPath = self.peripheralsTableView.indexPathForSelectedRow {
                            let peripheral = centralManager?.peripherals[indexPath.row]
                            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                            controller.peripheral = peripheral
                            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                            controller.navigationItem.leftItemsSupplementBackButton = true
                        }
        }
    }
    
    
    
    func getConnectedPeripherals(filterUUID:CBUUID?) -> NSArray {
        var retreivedPeripherals : NSArray?
        
        if filterUUID != nil {
            
            retreivedPeripherals     = (centralManager?.bleManager?.retrieveConnectedPeripherals(withServices: [filterUUID!]))! as NSArray
        }
        
        return retreivedPeripherals!
    }
    

    
    
    //MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateBLEState(success: Bool, message:String) {
        
        let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        if !success {
            alert.message = message
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        scanningState(active:true)
        
    }
    
    
    func centralManagerDidDiscoverPeripherals()
    {
        
        DispatchQueue.main.async {
            self.peripheralsTableView.reloadData()
        }
        
    }
    
    
    func centralManagerDidRetrieveConnectedPeripherals(peripherals: [CBPeripheral])
    {
        
    }
    
    
    func centralManager(_ central: CBCentralManager,didRetrievePeripherals peripherals: [CBPeripheral])
    {
        
    }
    
    
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if centralManager?.peripherals.count == 0
        {
            peripheralsTableView.isHidden = true
            emptyView.isHidden  = false
            
        }
        else
        {
            peripheralsTableView.isHidden = false
            emptyView.isHidden = true
            
        }
        
        return (centralManager?.peripherals.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.peripheralsTableView.dequeueReusableCell(withIdentifier: "peripheralCell", for: indexPath) as! MasterViewTableViewCell
        
   
            let peripheral = (centralManager?.peripherals[indexPath.row])
            
            
            cell.deviceName.text            = peripheral?.name()
            cell.deviceDescription.text     = peripheral?.description
            
            cell.deviceIcon.image           = appImages.getImgPeripheralCategory(deviceName: (peripheral?.name())!)
            cell.connectionStatus.image     = appImages.getImgConnectionStatus(isConnected: (peripheral?.isConnected)!)
            cell.signalStrength.image       = appImages.getImgRSSIStatus(rssiValue: (peripheral?.RSSI)!)
             
        
        return cell
        
        
    }
    
    
}

