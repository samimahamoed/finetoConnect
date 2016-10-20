//
//  CharacteristicsViewController.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 16/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth

class CharacteristicsViewController: UITableViewController,centralManagerDelegate {

    @IBOutlet var characteristicsTableView: UITableView!
 
 
    
    
    var centralManager:CentralManager?
    
    var peripheral:Peripherals?
    
    var service    : CBService? {
        didSet {
            
            centralManager                                   = CentralManager.singleToneInstance
            
            centralManager?.characteristicsViewDelegate      = self
            
            service?.peripheral.delegate                     = centralManager

            service?.peripheral.discoverCharacteristics(nil, for: service!)
        }
    }
    
    var timer       :Timer?
    var colorMemo   :UIColor?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
       
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.characteristicsTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView() {
        
        
        if (self.service?.peripheral) != nil {
            
           
            
            self.timer = Timer.scheduledTimer(withTimeInterval: Double(Constants.app.UI_REFRESH_RATE),
                                              repeats: true,
                                              block: {_ in
                                                
                                   
                                                
                                             
                                                
                }
            )
            
            
            
            
        }
    }
    
    
    func insertNewObject(_ sender: Any) {
       
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
       //     if let indexPath = self.tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! Peripherals
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.peripheral = object 
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
  //          }
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
    
 
    
    func didDiscoverCharacteristics(peripheral: CBPeripheral, error: Error?)
    {
        NSLog("didDiscoverCharacteristics, characteristicsViewController ")
        
        if peripheral == self.service?.peripheral {
            
            DispatchQueue.main.async {
            
                if(error==nil){
                   self.characteristicsTableView.reloadData()
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
    
    
    func didUpdateNotificationStateForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    {
        NSLog("didUpdateNotificationStateForCharacteristic, characteristicsViewController ")
    
        if peripheral == self.service?.peripheral {

            if(error==nil){
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    
                self.present(alert, animated: true, completion: nil)
                 //TODO: Reattempt
                return
            }
        }

    
    }
    
    func  didUpdateValueForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    {
        NSLog(" didUpdateValueForCharacteristic, characteristicsViewController ")
        
        if peripheral == self.service?.peripheral {
            
            
            
            if(error==nil){
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                //TODO: Reattempt
                return
            }else{
                DispatchQueue.main.async {
                    self.characteristicsTableView.reloadData()
                }
                
                //TODO: Return ACK if notification
                return
            }
            
            
        }
        
        
    }
    
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.service?.characteristics?.count {
            return count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characteristicsCell", for: indexPath) as! characteristicsTableViewCell
        
        if let characterstics = self.service?.characteristics?[indexPath.row] {
            cell.Name.text  = Characteristics.getCharacteristicsName(uuid:characterstics.uuid)
            cell.UUID.text  = characterstics.uuid.uuidString
           
            
            if characterstics.value != nil {
                cell.value.text = self.peripheral?.valueToString(value: characterstics.value!)
            }
            
        
            cell.property.text = Characteristics.getCharacteristicsPropertie(property: characterstics.properties);
     
            if(self.peripheral?.canWriteValue(property: characterstics.properties))!{
                cell.writeBtn.setImage(UIImage(named:"write"), for: .normal)
                cell.writeBtn.isEnabled = true
            }else{
                cell.writeBtn.setImage(UIImage(named:"null"), for: .normal)
                cell.writeBtn.isEnabled = false
            }
        }
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    


}
