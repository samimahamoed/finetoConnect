//
//  Constants.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 06/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import Foundation

struct Constants {

    
    struct app {
        static let PERIPHERAL_SCAN_TIMEOUT_PERIOD = 20
    }
    
    struct queues {
        static let bleCentralManagerSerialQueue = "com.fineto.bleCentralManagerQueue"
    }

    struct MSGs {
        struct SCAN_RESULT {
                static let UNKNOWN_DEVICE = "Unknown device"
        }
        
        
        
        struct CENTRAL_MANAGER_STATE {
            static let unknown          = "The current state of the central manager is unknown; an update is imminent"
            static let resetting        = "The connection with the system service was momentarily lost; an update is imminent."
            static let unsupported      = "The platform does not support Bluetooth low energy."
            static let unauthorized     = "The app is not authorized to use Bluetooth low energy."
            static let poweredOff       = "Bluetooth is currently powered off."
            static let poweredOn        = "Bluetooth is currently powered on and available to use."
        }
    
    
    
    }
    
    

}
