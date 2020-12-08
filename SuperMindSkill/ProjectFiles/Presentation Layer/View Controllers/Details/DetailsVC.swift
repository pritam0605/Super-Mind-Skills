//
//  DetailsVC.swift
//  SuperMindSkill
//
//  Created by Dipika on 07/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class DetailsVC: BaseViewController {
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var textViewDetailsText: UITextView!
    var strHeader = ""
    var strTextviwetext = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwHeader?.lableTitle.text = "Detail"
        self.vwHeader?.headerType = .back
        self.vwHeader?.tintColor = .black
        self.vwHeader?.rightButton2.isHidden = false
        self.vwHeader?.lableTitle.textAlignment = .center
        self.vwHeader?.rightButton2.tintColor = .white
        self.vwHeader?.backgroundColor = .white
        self.lblHeaderTitle.text = strHeader
        self.textViewDetailsText.text = strTextviwetext

        
    }
    

   

}
