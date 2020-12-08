//
//  DatePickerView.swift
//  BusMyCar
//
//  Created by Prakash Metia on 27/07/17.
//  Copyright © 2017 MET. All rights reserved.
//

import UIKit

@objc protocol DatePickerDelegate {
    
    func selectedDate(selectedDate:Date)
    
}

class DatePickerView: UIView {

    var delegate:DatePickerDelegate?
    @IBOutlet weak var dtPicker:UIDatePicker!
    //var selectedDate = Date()

    
    
    @IBAction func barBtnAction(sender:UIBarButtonItem) {
        
        if sender.tag == 1 {
            //print(dtPicker.date)
            delegate?.selectedDate(selectedDate: dtPicker.date)
            
        }
        
        MyBasics.hideDatePickerView()
        
    }
    
}
