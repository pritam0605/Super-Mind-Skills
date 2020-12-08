//
//  CountryPickerView.swift
//  SuperMindSkill
//
//  Created by Abhik on 29/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import MRCountryPicker



struct MyCountry {
    var code: String?
    var name: String?
    var phoneCode: String?
  

    init(code: String?, name: String?, phoneCode: String?) {
        self.code = code
        self.name = name
        self.phoneCode = phoneCode
    }
}



@objc protocol CustomCountryPickerDelegate {
    
    func GetSelectedCountryNameAndCode(CountryName:String,CountryPhoneCode:String,CountryNameCode: String)

}
class CountryPickerView: UIView {
    
    var myDelegate:CustomCountryPickerDelegate?
    var selectedIndex = 0
    @IBOutlet weak var countryPicker: UIPickerView!
    
    var selectedCountryName = "India"
    var selectedCountryPhoneCode = "91"
    var selectedCountryNameCode = "IN"
    
    
    var countries: [MyCountry]!
    
    func ReloadCountryPickerView() {
        
        countries = countryNamesByCode()
        
        selectedCountryName = "\(countries[0].name!)"
        selectedCountryPhoneCode = "\(countries[0].phoneCode!)"
        selectedCountryNameCode = "\(countries[0].code!)"
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.reloadAllComponents()
        
    }
    
    func countryNamesByCode() -> [MyCountry] {
        var countries = [MyCountry]()
        let frameworkBundle = Bundle(for: type(of: self))
        guard let jsonPath = frameworkBundle.path(forResource: "MyCountryList", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return countries
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                
                for jsonObject in jsonObjects {
                    
                    guard let countryObj = jsonObject as? NSDictionary else {
                        return countries
                    }
                    
                    guard let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let name = countryObj["name"] as? String else {
                        return countries
                    }
                    
                    let country = MyCountry(code: code, name: name, phoneCode: phoneCode)
                    countries.append(country)
                }
                
            }
        } catch {
            return countries
        }
        return countries
    }
    
    @IBAction func barBtnAction(sender:UIBarButtonItem) {
        
        if sender.tag == 1 {
            
            myDelegate?.GetSelectedCountryNameAndCode(CountryName: selectedCountryName, CountryPhoneCode: selectedCountryPhoneCode, CountryNameCode: selectedCountryNameCode)
        }
        
        MyBasics.hideCountryPicker()
        
    }
    
}
extension CountryPickerView:MRCountryPickerDelegate{
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        selectedCountryName = name
        selectedCountryPhoneCode = phoneCode
        selectedCountryNameCode = countryCode
    }
}
extension CountryPickerView:UIPickerViewDelegate,UIPickerViewDataSource{
    
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return countries.count
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          
        return "\(countries[row].name!) \("(")\(countries[row].code!)\(")") \(" ")\(countries[row].phoneCode!)"
          
      }
      
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let myComponent = countries[row]
        
        selectedCountryName = myComponent.name ?? ""
        selectedCountryPhoneCode = myComponent.phoneCode ?? ""
        selectedCountryNameCode = myComponent.code ?? ""
        
    }
      
}
