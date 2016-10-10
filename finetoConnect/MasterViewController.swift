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
}


class MasterViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CBCentralManagerDelegate{
    
    
    
    
    @IBOutlet var peripheralsTableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var scanOrnotBtn: UIBarButtonItem!
    @IBOutlet var busyScannig: UIActivityIndicatorView!
    
    

    
    
    
    var detailViewController: DetailViewController? = nil
    
    var bleManager                  : CBCentralManager?
    var timer                       : Timer?
 //   var timeoutCounter              : Int16 = Int16(Constants.app.PERIPHERAL_SCAN_TIMEOUT_PERIOD)
    
    var peripherals                 = [Peripherals]()
    var flags                       = flagsType(scanning: false)
    
    
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //busyScannig                             = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        busyScannig.hidesWhenStopped            = true
        busyScannig.startAnimating()
       
        
        
        
        let serialQueue = DispatchQueue.init(label: Constants.queues.bleCentralManagerSerialQueue)
        bleManager = CBCentralManager(delegate: self, queue: serialQueue)
        
        
        if let split = self.splitViewController {
            
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    
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
    
    
    func scanForPeripherals(enable:Bool, filterUUID:CBUUID?) -> Bool {
        
        
        guard bleManager?.state == CBManagerState.poweredOn
            else
        {
            let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            switch (bleManager?.state)! {
            case .unknown:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.unknown
            case .resetting:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.resetting
            case .unsupported:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.unsupported
            case .unauthorized:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.unauthorized
            default:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.unknown
            }
            
            self.present(alert, animated: true, completion: nil)
            
            NSLog("%s", alert.message! as String)
            
            return false
        }
        
        
        DispatchQueue.main.async {
            if enable == true {
                let options: NSDictionary = NSDictionary(objects: [NSNumber(value: true)], forKeys: [CBCentralManagerScanOptionAllowDuplicatesKey as NSCopying])
                if filterUUID != nil {
                    self.bleManager?.scanForPeripherals(withServices: [filterUUID!], options: options as? [String : AnyObject])
                } else {
                    self.bleManager?.scanForPeripherals(withServices: nil, options: options as? [String : AnyObject])
                }
                
                self.timer = Timer.scheduledTimer(timeInterval: Double(Constants.app.PERIPHERAL_SCAN_TIMEOUT_PERIOD),
                                                  target: self,
                                                  selector: #selector(self.scanTimerEvent),
                                                  userInfo: nil,
                                                  repeats: false)
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.bleManager?.stopScan()
            }
        }
        
        return true
    }
    
    
    func scanningState(active:Bool){
        
        if active {
            busyScannig.startAnimating()
            flags.scanning = true
            scanOrnotBtn.title = "Cancel"
            
            let success = self.scanForPeripherals(enable: true,filterUUID: nil)
            if !success {/*TODO: log error*/ }
            return
        }
        
        
            timer?.invalidate()
            timer = nil
            busyScannig.stopAnimating()
            flags.scanning = false
            scanOrnotBtn.title = "Scan"
            let success  = scanForPeripherals(enable: false, filterUUID: nil)
            if !success {/*TODO: log error*/ }
    }
    
    
    
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            //            if let indexPath = self.tableView.indexPathForSelectedRow {
            //                let object = objects[indexPath.row] as! NSDate
            //                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            //                controller.detailItem = object
            //                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            //                controller.navigationItem.leftItemsSupplementBackButton = true
            //            }
        }
    }
    
    
    
    func getConnectedPeripherals(filterUUID:CBUUID?) -> NSArray {
        var retreivedPeripherals : NSArray?
        
        if filterUUID != nil {
            
            retreivedPeripherals     = (bleManager?.retrieveConnectedPeripherals(withServices: [filterUUID!]))! as NSArray
        }
        
        return retreivedPeripherals!
    }
    

    
    
    //MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        guard central.state == CBManagerState.poweredOn
            else
        {
            let alert = UIAlertController(title: "Error", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            switch central.state {
            case .unknown:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.unknown
            case .resetting:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.resetting
            case .unsupported:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.unsupported
            case .unauthorized:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.unauthorized
            default:
                alert.message = Constants.MSGs.CENTRAL_MANAGER_STATE.unknown
            }
            
            self.present(alert, animated: true, completion: nil)
            
            NSLog("%s", alert.message! as String)
            
            return
        }
        
        
        
        scanningState(active:true)
        // peripherals = NSMutableArray(array: self.getConnectedPeripherals(filterUUID: nil))
        
        
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
        
        DispatchQueue.main.async {
            self.peripheralsTableView.reloadData()
        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager,didRetrieveConnectedPeripherals peripherals: [CBPeripheral])
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
        
        if peripherals.count == 0
        {
            peripheralsTableView.isHidden = true
            emptyView.isHidden  = false
            
        }
        else
        {
            peripheralsTableView.isHidden = false
            emptyView.isHidden = true
            
        }
        
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.peripheralsTableView.dequeueReusableCell(withIdentifier: "peripheralCell", for: indexPath) as! MasterViewTableViewCell
        
        
        let peripheral = (peripherals as NSArray).object(at: indexPath.row) as! Peripherals
        
        
        
        cell.deviceName.text            = peripheral.name()
        cell.deviceDescription.text     = peripheral.description
        
        cell.deviceIcon.image           = appImages.getImgPeripheralCategory(deviceName: peripheral.name())
        cell.connectionStatus.image     = appImages.getImgConnectionStatus(isConnected: peripheral.isConnected)
        cell.signalStrength.image       = appImages.getImgRSSIStatus(rssiValue: peripheral.RSSI)
        
        
        
        return cell
        
        
    }
    
    
}

