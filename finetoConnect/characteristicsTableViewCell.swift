//
//  characteristicsTableViewCell.swift
//  finetoConnect
//
//  Created by Sami Mahamoud Mahamoed on 16/10/2016.
//  Copyright © 2016 Sami Mahamoud Mahamoed. All rights reserved.
//

import UIKit

class characteristicsTableViewCell: UITableViewCell {

    
    @IBOutlet var Name: UILabel!
    
    @IBOutlet var UUID: UILabel!
    
    @IBOutlet var value: UITextField!
    
    @IBOutlet var property: UILabel!
    
    @IBOutlet var readBtn: UIButton!
    
    @IBOutlet var writeBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
