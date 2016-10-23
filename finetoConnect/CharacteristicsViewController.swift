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
    
    
    
    
  
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
    
 
    
    func didDiscoverCharacteristics(peripheral: CBPeripheral, service: CBService,error: Error?)
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

            guard error==nil else {
              DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                //TODO: Reattempt
                
               
              }
                
                return
            }
        }

    
    }
    
    func  didUpdateValueForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    {
        NSLog(" didUpdateValueForCharacteristic, characteristicsViewController ")
        
        if peripheral == self.service?.peripheral {
            
          DispatchQueue.main.async {
            if(error==nil){
               
                    self.characteristicsTableView.reloadData()
                
                
                //TODO: Return ACK if notification
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
    
    func   didWriteValueForCharacteristic(peripheral: CBPeripheral,characteristic: CBCharacteristic, error: Error?)
    {
        NSLog(" didUpdateValueForCharacteristic, characteristicsViewController ")
        
        if peripheral == self.service?.peripheral {
            
        DispatchQueue.main.async {
            if(error==nil){
               
                    self.characteristicsTableView.reloadData()
                
                
                //TODO: Return ACK if notification
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
    
    
   
    
    // MARK: - Table View
    
    func writeBtnEvent(_ sender: UIButton) -> Void {
        let cell = characteristicsTableView.viewWithTag(sender.tag) as! characteristicsTableViewCell
       
       
        if let characterstics = self.service?.characteristics?[sender.tag] {
            
            guard cell.value.text == nil else {
                self.peripheral?.writeCharacteristicValue(value: cell.value.text!,
                                                          characteristic: characterstics,
                                                          type: CBCharacteristicWriteType.withoutResponse)
                
                return
            }
            
            
            let alert = UIAlertController(title: "Error",
                                          message: Constants.MSGs.ERROR_LOG.NullInput + String("row  \(sender.tag)"),
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
   
        }
        
    }
    
    func readBtnEvent(_ sender: UIButton) -> Void {
        
        if let characterstics = self.service?.characteristics?[sender.tag] {
         
                characterstics.service.peripheral.readValue(for: characterstics)
        }
    }
    
    
    
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
        cell.tag = indexPath.row
        
        if let characterstics = self.service?.characteristics?[indexPath.row] {
            cell.Name.text  = Characteristics.getCharacteristicsName(uuid:characterstics.uuid)
            cell.UUID.text  = characterstics.uuid.uuidString
           
            
            cell.value.tag = indexPath.row
            if characterstics.value != nil {
                cell.value.text = self.peripheral?.valueToString(value: characterstics.value!)
            }
            
            
            cell.property.text = Characteristics.getCharacteristicsPropertie(property: characterstics.properties);
            
            
            cell.writeBtn.tag = indexPath.row
            cell.writeBtn.addTarget(self, action: #selector(self.writeBtnEvent(_:)), for: UIControlEvents.touchUpInside)
            
            if(self.peripheral?.canWriteValue(property: characterstics.properties))!{
                //cell.writeBtn.isHidden  = false
                cell.writeBtn.isEnabled = true
                cell.value.isEnabled = true
            }else{
                //cell.writeBtn.isHidden  = true
                cell.writeBtn.isEnabled = false
                cell.value.isEnabled    = false
            }
            
            cell.readBtn.tag = indexPath.row
            cell.readBtn.addTarget(self, action: #selector(self.readBtnEvent(_:)), for: UIControlEvents.touchUpInside)
            if(self.peripheral?.canReadValue(property: characterstics.properties))!{
                cell.readBtn.isHidden  = false
                cell.readBtn.isEnabled = true
            }else{
                cell.readBtn.isHidden  = true
                cell.readBtn.isEnabled = false
            }
        }
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    

    


}
