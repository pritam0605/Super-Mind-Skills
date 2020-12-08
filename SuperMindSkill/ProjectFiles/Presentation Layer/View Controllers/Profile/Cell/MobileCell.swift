//
//  MobileCell.swift
//  HMS
//
//  Created by Dipika on 10/01/20.
//  Copyright © 2020 MET Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class MobileCell: UITableViewCell {
    
    @IBOutlet weak var btnSelectCountry: UIButton!

    @IBOutlet weak var lblCountryCode: UILabel!
    
    @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         txtMobileNumber.titleFormatter = { $0 }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
