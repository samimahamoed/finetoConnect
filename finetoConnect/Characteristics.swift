//
//  Characteristics.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 16/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit
import CoreBluetooth
class Characteristics: NSObject {

    static private var characteristicsUUIDS:[CBUUID:String] = [
        //custom 128 bit uuids
        
        CBUUID.init(string:"0000BEEF-1212-EFDE-1523-785FEF13D123"):"FINETO Power switch value",
        CBUUID.init(string:"19581525-C3BB-41E1-BCF9-DCC98D1737C8"):"FINETO Power switch write",
        CBUUID.init(string:"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"):"NordicSemiconductor UART",
        CBUUID.init(string:"00001908-0000-1000-8000-00805F9B34FB"):"NordicSemiconductor DFU",
        CBUUID.init(string:"00001909-0000-1002-8000-00805F9B34FB"):"Apple ANCS",
        
        //adopted 16 or 32 bit uuids
        CBUUID.init(string:"2A7E"):"Aerobic Heart Rate Lower Limit",
        CBUUID.init(string:"2A84"):"Aerobic Heart Rate Upper Limit",
        CBUUID.init(string:"2A7F"):"Aerobic Threshold",
        CBUUID.init(string:"2A80"):"Age",
        CBUUID.init(string:"2A5A"):"Aggregate",
        CBUUID.init(string:"2A43"):"Alert Category ID",
        CBUUID.init(string:"2A42"):"Alert Category ID Bit Mask",
        CBUUID.init(string:"2A06"):"Alert Level",
        CBUUID.init(string:"2A44"):"Alert Notification Control Point",
        CBUUID.init(string:"2A3F"):"Alert Status",
        CBUUID.init(string:"2AB3"):"Altitude",
        CBUUID.init(string:"2A81"):"Anaerobic Heart Rate Lower Limit",
        CBUUID.init(string:"2A82"):"Anaerobic Heart Rate Upper Limit",
        CBUUID.init(string:"2A83"):"Anaerobic Threshold",
        CBUUID.init(string:"2A58"):"Analog",
        CBUUID.init(string:"2A73"):"Apparent Wind Direction",
        CBUUID.init(string:"2A72"):"Apparent Wind Speed",
        CBUUID.init(string:"2A01"):"Appearance",
        CBUUID.init(string:"2AA3"):"Barometric Pressure Trend",
        CBUUID.init(string:"2A19"):"Battery Level",
        CBUUID.init(string:"2A49"):"Blood Pressure Feature",
        CBUUID.init(string:"2A35"):"Blood Pressure Measurement",
        CBUUID.init(string:"2A9B"):"Body Composition Feature",
        CBUUID.init(string:"2A9C"):"Body Composition Measurement",
        CBUUID.init(string:"2A38"):"Body Sensor Location",
        CBUUID.init(string:"2AA4"):"Bond Management Control Point",
        CBUUID.init(string:"2AA5"):"Bond Management Features",
        CBUUID.init(string:"2A22"):"Boot Keyboard Input Report",
        CBUUID.init(string:"2A32"):"Boot Keyboard Output Report",
        CBUUID.init(string:"2A33"):"Boot Mouse Input Report",
        CBUUID.init(string:"2AA6"):"Central Address Resolution",
        CBUUID.init(string:"2AA8"):"CGM Feature",
        CBUUID.init(string:"2AA7"):"CGM Measurement",
        CBUUID.init(string:"2AAB"):"CGM Session Run Time",
        CBUUID.init(string:"2AAA"):"CGM Session Start Time",
        CBUUID.init(string:"2AAC"):"CGM Specific Ops Control Point",
        CBUUID.init(string:"2AA9"):"CGM Status",
        CBUUID.init(string:"2A5C"):"CSC Feature",
        CBUUID.init(string:"2A5B"):"CSC Measurement",
        CBUUID.init(string:"2A2B"):"Current Time",
        CBUUID.init(string:"2A66"):"Cycling Power Control Point",
        CBUUID.init(string:"2A65"):"Cycling Power Feature",
        CBUUID.init(string:"2A63"):"Cycling Power Measurement",
        CBUUID.init(string:"2A64"):"Cycling Power Vector",
        CBUUID.init(string:"2A99"):"Database Change Increment",
        CBUUID.init(string:"2A85"):"Date of Birth",
        CBUUID.init(string:"2A86"):"Date of Threshold Assessment",
        CBUUID.init(string:"2A08"):"Date Time",
        CBUUID.init(string:"2A0A"):"Day Date Time",
        CBUUID.init(string:"2A09"):"Day of Week",
        CBUUID.init(string:"2A00"):"Device Name",
        CBUUID.init(string:"2A7B"):"Dew Point",
        CBUUID.init(string:"2A56"):"Digital",
        CBUUID.init(string:"2A0D"):"DST Offset",
        CBUUID.init(string:"2A6C"):"Elevation",
        CBUUID.init(string:"2A87"):"Email Address",
        CBUUID.init(string:"2A0C"):"Exact Time 256",
        CBUUID.init(string:"2A88"):"Fat Burn Heart Rate Lower Limit",
        CBUUID.init(string:"2A89"):"Fat Burn Heart Rate Upper Limit",
        CBUUID.init(string:"2A26"):"Firmware Revision String",
        CBUUID.init(string:"2A8A"):"First Name",
        CBUUID.init(string:"2A8B"):"Five Zone Heart Rate Limits",
        CBUUID.init(string:"2AB2"):"Floor Number",
        CBUUID.init(string:"2A8C"):"Gender",
        CBUUID.init(string:"2A51"):"Glucose Feature",
        CBUUID.init(string:"2A18"):"Glucose Measurement",
        CBUUID.init(string:"2A34"):"Glucose Measurement Context",
        CBUUID.init(string:"2A74"):"Gust Factor",
        CBUUID.init(string:"2A27"):"Hardware Revision String",
        CBUUID.init(string:"2A39"):"Heart Rate Control Point",
        CBUUID.init(string:"2A8D"):"Heart Rate Max",
        CBUUID.init(string:"2A37"):"Heart Rate Measurement",
        CBUUID.init(string:"2A7A"):"Heat Index",
        CBUUID.init(string:"2A8E"):"Height",
        CBUUID.init(string:"2A4C"):"HID Control Point",
        CBUUID.init(string:"2A4A"):"HID Information",
        CBUUID.init(string:"2A8F"):"Hip Circumference",
        CBUUID.init(string:"2A6F"):"Humidity",
        CBUUID.init(string:"2A2A"):"IEEE 11073-20601 Regulatory Certification Data List",
        CBUUID.init(string:"2AAD"):"Indoor Positioning Configuration",
        CBUUID.init(string:"2A36"):"Intermediate Cuff Pressure",
        CBUUID.init(string:"2A1E"):"Intermediate Temperature",
        CBUUID.init(string:"2A77"):"Irradiance",
        CBUUID.init(string:"2AA2"):"Language",
        CBUUID.init(string:"2A90"):"Last Name",
        CBUUID.init(string:"2AAE"):"Latitude",
        CBUUID.init(string:"2A6B"):"LN Control Point",
        CBUUID.init(string:"2A6A"):"LN Feature",
        CBUUID.init(string:"2AB1"):"Local East Coordinate",
        CBUUID.init(string:"2AB0"):"Local North Coordinate",
        CBUUID.init(string:"2A0F"):"Local Time Information",
        CBUUID.init(string:"2A67"):"Location and Speed Characteristic",
        CBUUID.init(string:"2AB5"):"Location Name",
        CBUUID.init(string:"2AAF"):"Longitude",
        CBUUID.init(string:"2A2C"):"Magnetic Declination",
        CBUUID.init(string:"2AA0"):"Magnetic Flux Density - 2D",
        CBUUID.init(string:"2AA1"):"Magnetic Flux Density - 3D",
        CBUUID.init(string:"2A29"):"Manufacturer Name String",
        CBUUID.init(string:"2A91"):"Maximum Recommended Heart Rate",
        CBUUID.init(string:"2A21"):"Measurement Interval",
        CBUUID.init(string:"2A24"):"Model Number String",
        CBUUID.init(string:"2A68"):"Navigation",
        CBUUID.init(string:"2A46"):"New Alert",
        CBUUID.init(string:"2A04"):"Peripheral Preferred Connection Parameters",
        CBUUID.init(string:"2A02"):"Peripheral Privacy Flag",
        CBUUID.init(string:"2A5F"):"PLX Continuous Measurement",
        CBUUID.init(string:"2A60"):"PLX Features",
        CBUUID.init(string:"2A5E"):"PLX Spot-Check Measurement",
        CBUUID.init(string:"2A50"):"PnP ID",
        CBUUID.init(string:"2A75"):"Pollen Concentration",
        CBUUID.init(string:"2A69"):"Position Quality",
        CBUUID.init(string:"2A6D"):"Pressure",
        CBUUID.init(string:"2A4E"):"Protocol Mode",
        CBUUID.init(string:"2A78"):"Rainfall",
        CBUUID.init(string:"2A03"):"Reconnection Address",
        CBUUID.init(string:"2A52"):"Record Access Control Point",
        CBUUID.init(string:"2A14"):"Reference Time Information",
        CBUUID.init(string:"2A4D"):"Report",
        CBUUID.init(string:"2A4B"):"Report Map",
        CBUUID.init(string:"2A92"):"Resting Heart Rate",
        CBUUID.init(string:"2A40"):"Ringer Control point",
        CBUUID.init(string:"2A41"):"Ringer Setting",
        CBUUID.init(string:"2A54"):"RSC Feature",
        CBUUID.init(string:"2A53"):"RSC Measurement",
        CBUUID.init(string:"2A55"):"SC Control Point",
        CBUUID.init(string:"2A4F"):"Scan Interval Window",
        CBUUID.init(string:"2A31"):"Scan Refresh",
        CBUUID.init(string:"2A5D"):"Sensor Location",
        CBUUID.init(string:"2A25"):"Serial Number String",
        CBUUID.init(string:"2A05"):"Service Changed",
        CBUUID.init(string:"2A28"):"Software Revision String",
        CBUUID.init(string:"2A93"):"Sport Type for Aerobic and Anaerobic Thresholds",
        CBUUID.init(string:"2A47"):"Supported New Alert Category",
        CBUUID.init(string:"2A48"):"Supported Unread Alert Category",
        CBUUID.init(string:"2A23"):"System ID",
        CBUUID.init(string:"2A6E"):"Temperature",
        CBUUID.init(string:"2A1C"):"Temperature Measurement",
        CBUUID.init(string:"2A1D"):"Temperature Type",
        CBUUID.init(string:"2A94"):"Three Zone Heart Rate Limits",
        CBUUID.init(string:"2A12"):"Time Accuracy",
        CBUUID.init(string:"2A13"):"Time Source",
        CBUUID.init(string:"2A16"):"Time Update Control Point",
        CBUUID.init(string:"2A17"):"Time Update State",
        CBUUID.init(string:"2A11"):"Time with DST",
        CBUUID.init(string:"2A0E"):"Time Zone",
        CBUUID.init(string:"2A71"):"True Wind Direction",
        CBUUID.init(string:"2A70"):"True Wind Speed",
        CBUUID.init(string:"2A95"):"Two Zone Heart Rate Limit",
        CBUUID.init(string:"2A07"):"Tx Power Level",
        CBUUID.init(string:"2AB4"):"Uncertainty",
        CBUUID.init(string:"2A45"):"Unread Alert Status",
        CBUUID.init(string:"2A9F"):"User Control Point",
        CBUUID.init(string:"2A9A"):"User Index",
        CBUUID.init(string:"2A76"):"UV Index",
        CBUUID.init(string:"2A96"):"VO2 Max",
        CBUUID.init(string:"2A97"):"Waist Circumference",
        CBUUID.init(string:"2A98"):"Weight",
        CBUUID.init(string:"2A9D"):"Weight Measurement",
        CBUUID.init(string:"2A9E"):"Weight Scale Feature",
        CBUUID.init(string:"2A79"):"Wind Chill",
        CBUUID.init(string:"1800"):"Generic Access",
        CBUUID.init(string:"1801"):"Generic Attribute"

        
        
    ]
    
    
    
    static func getCharacteristicsName(uuid:CBUUID) -> String {
        if let name  = self.characteristicsUUIDS[uuid] {
            return name
        }
        
        return Constants.MSGs.RESULT.UNKNOWN_Characteristic
    }
    
    static func getCharacteristicsUUID(characteristicName:String) -> CBUUID? {
   
        for name in self.characteristicsUUIDS {
            
            if name.value == characteristicName {
                return name.key
            }
        }
        
        
        return nil
    }
    
    
    static func getCharacteristicsPropertie(property:CBCharacteristicProperties) -> String {
     
        var charProperty = ""
        
        if property.contains(CBCharacteristicProperties.broadcast) {
            charProperty += "broadcast,"
        }
        
        if property.contains(CBCharacteristicProperties.read) {
            charProperty += "read,"
        }
        
        if property.contains(CBCharacteristicProperties.writeWithoutResponse) {
            charProperty += "write Without Response,"
        }
        
        if property.contains(CBCharacteristicProperties.write) {
            charProperty += "write,"
        }
        
        if property.contains(CBCharacteristicProperties.notify) {
            charProperty += "notify,"
        }
        
        if property.contains(CBCharacteristicProperties.indicate) {
            charProperty += "indicate,"
        }
        
        if property.contains(CBCharacteristicProperties.authenticatedSignedWrites) {
            charProperty += "authenticated Signed Writes,"
        }
        
        if property.contains(CBCharacteristicProperties.extendedProperties) {
            charProperty += "extended Properties,"
        }
        
        if property.contains(CBCharacteristicProperties.notifyEncryptionRequired) {
            charProperty += "notifyEncryptionRequired"
        }
        
        if property.contains(CBCharacteristicProperties.indicateEncryptionRequired) {
            charProperty += "indicateEncryptionRequired,"
        }
        
        if charProperty == "" {
             charProperty += Constants.MSGs.RESULT.UNKNOWN_Property
        }
        
        
        
        return charProperty
    }
    
    
    static func getCharacteristicsPropertieDescription(property:CBCharacteristicProperties) -> (String,String) {
        

        switch property {
            
        case CBCharacteristicProperties.broadcast:
            return ("broadcast","The characteristic’s value can be broadcast using a characteristic configuration descriptor.")
        case CBCharacteristicProperties.read:
            return ("read","The characteristic’s value can be read.")
        case CBCharacteristicProperties.writeWithoutResponse:
            return ("writeWithoutResponse","The characteristic’s value can be written, without a response from the peripheral to indicate that the write was successful.")
        case CBCharacteristicProperties.write:
            return ("write","The characteristic’s value can be written, with a response from the peripheral to indicate that the write was successful.")
        case CBCharacteristicProperties.indicate:
            return ("indicate","Indications of the characteristic’s value are permitted, with a response from the central to indicate that the indication was received.")
        case CBCharacteristicProperties.authenticatedSignedWrites:
            return ("authenticatedSignedWrites","Signed writes of the characteristic’s value are permitted, without a response from the peripheral to indicate that the write was successful.")
        case CBCharacteristicProperties.extendedProperties:
            return ("extendedProperties","Additional characteristic properties are defined in the characteristic extended properties descriptor.")
        case CBCharacteristicProperties.notifyEncryptionRequired:
            return ("notifyEncryptionRequired","Only trusted devices can enable notifications of the characteristic’s value.")
        case CBCharacteristicProperties.indicateEncryptionRequired:
            return ("indicateEncryptionRequired","Only trusted devices can enable indications of the characteristic’s value.")
        default:
            return (Constants.MSGs.RESULT.UNKNOWN_Property,Constants.MSGs.RESULT.UNKNOWN_Property)
        }
        
    }
    
    
   }
