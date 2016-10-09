//
//  MasterViewTableViewCell.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 08/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit

class MasterViewTableViewCell: UITableViewCell {

    @IBOutlet var deviceIcon: UIImageView!
    @IBOutlet var signalStrength: UIImageView!
    @IBOutlet var connectionStatus: UIImageView!
    @IBOutlet var deviceName: UILabel!
    @IBOutlet var deviceDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
