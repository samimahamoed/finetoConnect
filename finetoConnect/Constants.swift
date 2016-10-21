//
//  Constants.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 06/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import Foundation
import CoreBluetooth
struct Constants {
    
    struct app {
        static let PERIPHERAL_SCAN_TIMEOUT_PERIOD = 20
        static let UI_REFRESH_RATE                = 0.500
        struct PERIPHERAL_STATE{
            static let UNKNOWN = -1
            static let disconnected     = CBPeripheralState.disconnected     //The peripheral is currently not connected to the central manager.
            static let connecting       = CBPeripheralState.connecting       //The peripheral is currently in the process of connecting to the central manager.
            static let connected        = CBPeripheralState.connected        //The peripheral is currently connected to the central manager.
            static let disconnecting    = CBPeripheralState.disconnecting    //The peripheral is currently in the process of disconnecting from the central manager.
        }
        struct dataFormat {
            static let row              = 0
            static let u8               = 1
            static let u16_to_BE        = 2
            static let u16_to_LE        = 3
            static let u32_to_BE        = 4
            static let u32_to_LE        = 5
            static let u64_to_BE        = 6
            static let u64_to_LE        = 7
        }
        struct identifiers {
            static let defaultSegue     = "segueSrv"
            static let switchSegue      = "segueSrvFINETOPowerswitchhandle"
        }
    }
    struct queues {
        static let bleCentralManagerSerialQueue = "com.fineto.bleCentralManagerQueue"
    }
    struct MSGs {
        struct CENTRAL_MANAGER_STATE {
            static let unknown                      = "The current state of the central manager is unknown; an update is imminent"
            static let resetting                    = "The connection with the system service was momentarily lost; an update is imminent."
            static let unsupported                  = "The platform does not support Bluetooth low energy."
            static let unauthorized                 = "The app is not authorized to use Bluetooth low energy."
            static let poweredOff                   = "Bluetooth is currently powered off."
            static let poweredOn                    = "Bluetooth is currently powered on and available to use."
        }
        struct ERROR_LOG {
            static let Conflict                     = "Conflicting state with expeced result"
            static let NullInput                    = "value cannot be null, table row"
        }
        struct RESULT {
            static let UNKNOWN_DEVICE               = "Unknown Device"
            static let UNKNOWN_Service              = "Unknown Service"
            static let UNKNOWN_Characteristic       = "Unknown Characteristic"
            static let UNKNOWN_Property             = "Unknown Characteristic Property"
        }
    }
}











