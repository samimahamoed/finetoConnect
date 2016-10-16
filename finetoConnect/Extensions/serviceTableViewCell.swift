//
//  serviceTableViewCell.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 15/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit

class serviceTableViewCell: UITableViewCell {

    @IBOutlet var Icon: UIImageView!
    @IBOutlet var type: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var Description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
