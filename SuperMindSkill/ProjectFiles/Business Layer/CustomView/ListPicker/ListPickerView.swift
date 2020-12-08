//
//  ListPickerView.swift
//  TryWrongPlace
//
//  Created by Prakash Metia on 12/05/17.
//  Copyright © 2017 MET. All rights reserved.
//

import UIKit

@objc protocol CustomListDelegate {
    
    func GetSelectedPickerItemIndex(Index:Int)
    //@objc optional func ListDidHide()
}

class ListPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    var myDelegate:CustomListDelegate?
    @IBOutlet weak var listPicker:UIPickerView!
    var itemsArr = Array<String>()
    var selectedIndex:Int! = 0
    
    func ReloadPickerView(dataArray:Array<String>) {
        
        listPicker.delegate = self
        listPicker.dataSource = self
        itemsArr = dataArray
        listPicker.reloadAllComponents()
        
    }
    
    // MARK:
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(itemsArr[row])"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedIndex = row
        
    }
    
    
    @IBAction func barBtnAction(sender:UIBarButtonItem) {
        
        if sender.tag == 1 && selectedIndex > -1 {
            
            myDelegate?.GetSelectedPickerItemIndex(Index:selectedIndex)
            
        }
        //myDelegate?.ListDidHide!()
        MyBasics.hideListView()
        
    }
    
    
    // MARK:
    
    
}
