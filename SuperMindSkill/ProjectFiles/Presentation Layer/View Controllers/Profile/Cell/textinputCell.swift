//
//  textinputCell.swift
//  HMS
//
//  Created by Dipika on 09/01/20.
//  Copyright © 2020 MET Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class textinputCell: UITableViewCell {
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewLast: UIView!
    @IBOutlet weak var lblFieldName: UILabel!
    @IBOutlet weak var lblFieldNameSecond: UILabel!
   
    @IBOutlet weak var txtFieldNameFirst: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFielsNameSecond: SkyFloatingLabelTextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         txtFieldNameFirst.titleFormatter = { $0 }
        txtFielsNameSecond.titleFormatter = { $0 }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
