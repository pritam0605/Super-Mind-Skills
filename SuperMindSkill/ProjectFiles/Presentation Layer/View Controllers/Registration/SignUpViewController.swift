//
//  SignUpViewController.swift
//  SuperMindSkill
//
//  Created by Abhik on 29/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import MRCountryPicker
class SignUpViewController: BaseViewController {
    @IBOutlet weak var tableRegistration: UITableView!
    @IBOutlet weak var btnSignUp: UIButton!
    var regModel = registrationModelClass()
 
    var countryListArray = ["", "", ""]
    var collectInfo = [String]()
    var regParam = [String : String]()
  
    var countrySelectedIndex = ""
 
    var selectedCountryCode = "+61"//""
    var selectedCountryNameCode = "AU"
    var selectedCountryName = "Australia"
    var isAcceptTermsAndCondition = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBlankArray()
    }
    
    enum Place_Holder:Int {
        case CELL_CONTENT_FIRST_NAME = 0
        case CELL_CONTENT_LAST_NAME
        case CELL_CONTENT_EMAIL
        case CELL_CONTENT_PHONE
        case CELL_CONTENT_PASSWORD
        case CELL_CONTENT_CONFIRM_PASSWORD
        
        
        case CELL_CONTENT_TOTAL
        func getPlaceHolderText() -> String {
            switch self {
            case .CELL_CONTENT_FIRST_NAME:
                return "First Name*"
            case .CELL_CONTENT_LAST_NAME:
                return "Last Name*"
            case .CELL_CONTENT_EMAIL:
                return "Email Address*"
            case .CELL_CONTENT_PHONE:
                return "Phone Number"
            case .CELL_CONTENT_PASSWORD:
                return "Password*"
            case .CELL_CONTENT_CONFIRM_PASSWORD:
                return "Confirm Password*"
                
            default:
                return ""
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnSignUp.layer.borderWidth = 2.0
        btnSignUp.layer.cornerRadius = btnSignUp.frame.size.height / 2
        btnSignUp.layer.borderColor = UIColor.clear.cgColor
    }
    
    //Contestant/Applicant Phone
    func getBlankArray() {
        collectInfo.removeAll()
        for _ in 0 ..< Place_Holder.CELL_CONTENT_TOTAL.rawValue {
            collectInfo.append("")
        }
        self.tableRegistration.reloadData()
        
    }
    
  
    @IBAction func buttonDidTapNext(_ sender: UIButton) {
        self.getDataFromTable()
    }
    @IBAction func buttonDidTapLogin(_ sender: UIButton) {
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnclickedTermsAndCondition(_ sender: UIButton) {
          sender.isSelected = !sender.isSelected
          isAcceptTermsAndCondition = !isAcceptTermsAndCondition
      }
    @IBAction func openTermsAndCondition(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(identifier: "TermsAndCondition") as! TermsAndCondition
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignUpViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == Place_Holder.CELL_CONTENT_PHONE.rawValue){
            let cell: CommonCellTableViewCell = self.tableRegistration.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell2", for: indexPath as IndexPath)as! CommonCellTableViewCell
            let typePersonal = Place_Holder.init(rawValue: indexPath.row)
            cell.cellText.placeholder = ""
            cell.cellText.delegate = self
            cell.cellText.tag = indexPath.row
            cell.cellText.isSecureTextEntry = false
            cell.cellText.text = "\(selectedCountryNameCode)\(" ") \(selectedCountryCode)"  //selectedCountryCode//selectedCountryName.count == 0 ? selectedCountryName : "\(selectedCountryName)(+\(selectedCountryCode))"
            
            
            cell.cellText.isUserInteractionEnabled = false
            cell.cellTextCountryCode.isUserInteractionEnabled = false
            cell.cellTextCountryCode.text = ""//selectedCountryCode.count == 0 ? selectedCountryCode : "+\(selectedCountryCode)"
            cell.cellTextPhone.placeholder = typePersonal?.getPlaceHolderText()
            
            cell.cellTextPhone.tag = indexPath.row
            cell.cellTextPhone.delegate = self
            cell.cellTextPhone.isUserInteractionEnabled = true
            cell.cellTextPhone.text = self.collectInfo[indexPath.row]
            cell.cellTextPhone?.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
            cell.cellTextPhone.keyboardType = .numberPad
            
            cell.btnInstance.tag = indexPath.row
            cell.btnInstance.addTarget(self, action: #selector(btnPickerCountrySelection), for: .touchUpInside)
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            
            
            
            cell.cellText.inputView = nil
            cell.cellText.reloadInputViews()
            
            return cell
        }else{
            
            let cell: CommonCellTableViewCell = self.tableRegistration.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell1") as! CommonCellTableViewCell
            let type = Place_Holder.init(rawValue: indexPath.row)
            cell.cellText.placeholder = type?.getPlaceHolderText()
            self.addValidation(myIndex: indexPath.row, cell: cell)
            
            cell.cellText.inputView = nil
            cell.cellText.reloadInputViews()
            cell.cellText.tag = indexPath.row
            cell.cellText.text = collectInfo[indexPath.row]
            cell.cellText.tag = indexPath.row
            cell.cellText.delegate = self
            
            cell.cellText.addTarget(self, action: #selector(self.textFieldValueChange(_:)), for: .editingChanged)
            
            cell.cellText.isUserInteractionEnabled = true
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .phone ? 60 : 75
    }
}

extension SignUpViewController {
    @objc func textFieldValueChange(_ txt: UITextField)  {
        // superviewOfClassType comes from IQ keyboard managr
        guard let cell: CommonCellTableViewCell = txt.superview?.superviewOfClassType(CommonCellTableViewCell.self) as? CommonCellTableViewCell else { return}
        guard let indexPath = self.tableRegistration.indexPath(for: cell)else { return}
        if let str = txt.text, str.count > 0 {
            self.collectInfo.remove(at: indexPath.row)
            self.collectInfo.insert(str, at: indexPath.row)
        }else{
            self.collectInfo.remove(at: indexPath.row)
            self.collectInfo.insert("", at: indexPath.row)
        }
        
    }
    
    
    func addValidation(myIndex: Int, cell : CommonCellTableViewCell) {
        let myType = Place_Holder.init(rawValue: myIndex)
        switch myType {
            
        case .CELL_CONTENT_FIRST_NAME? , .CELL_CONTENT_LAST_NAME?:
            cell.cellText.isSecureTextEntry = false
            cell.cellText.keyboardType = .asciiCapable
            
        case .CELL_CONTENT_PHONE?:
            cell.cellText.isSecureTextEntry = false
            cell.cellText.keyboardType = .phonePad
            
        case .CELL_CONTENT_PASSWORD?,.CELL_CONTENT_CONFIRM_PASSWORD?:
            cell.cellText.isSecureTextEntry = true
            
        default:
            cell.cellText.isSecureTextEntry = false
            break
            
        }
    }
    
    func getDataFromTable()  {
        
        if self.validation() {
            regModel.apiForRegistration(firstname: collectInfo[Place_Holder.CELL_CONTENT_FIRST_NAME.rawValue],
                                        lastname: collectInfo[Place_Holder.CELL_CONTENT_LAST_NAME.rawValue],
                                        email: collectInfo[Place_Holder.CELL_CONTENT_EMAIL.rawValue],
                                        mobile: collectInfo[Place_Holder.CELL_CONTENT_PHONE.rawValue],
                                        password: collectInfo[Place_Holder.CELL_CONTENT_PASSWORD.rawValue],
                                        country_code: selectedCountryCode) {(status, message, dict) in
                                            if(status == 0){
                                                DispatchQueue.main.async {
                                                    self.navigateToOTP(email: dict["email"]!, otp: dict["otp"]!)
                                                }
                                            }else{
                                                
                                                DispatchQueue.main.async {
                                                    showAlertMessage(title: App_Title, message: message, vc: self)
                                                }
                                            }
            }
        }
    }
    func navigateToOTP(email:String,otp:String){
        let vc = self.storyboard?.instantiateViewController(identifier: "OTPVC") as! OTPVC
        vc.emailAddress = email
        vc.sentOtp = otp
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func validation() -> Bool {
        guard !collectInfo[Place_Holder.CELL_CONTENT_FIRST_NAME.rawValue].isEmpty else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_FIRST_BLANK, vc: self)
            return false
        }
        guard !collectInfo[Place_Holder.CELL_CONTENT_LAST_NAME.rawValue].isEmpty else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_LAST_BLANK, vc: self)
            return false
        }
        
        guard !collectInfo[Place_Holder.CELL_CONTENT_PASSWORD.rawValue].isEmpty else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PASSWORD_BLANK, vc: self)
            return false
        }
        guard !(self.selectedCountryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)else{
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_COUNTRY_BLANK, vc: self)
            return false
        }
        guard !(selectedCountryCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)else{
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_COUNTRY_BLANK, vc: self)
            return false
        }
        guard !(collectInfo[Place_Holder.CELL_CONTENT_PHONE.rawValue].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)else{
            
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_BLANK, vc: self)
            return false
        }
        /*
        if selectedCountryCode.contains("+") {
            guard  MyBasics.isValidPhoneNumberByCountry(numberStr: "\(selectedCountryCode )\(collectInfo[Place_Holder.CELL_CONTENT_PHONE.rawValue])") else {
                showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_COUNTRY_BLANK, vc: self)
                return false
            }
        }else{
            guard  MyBasics.isValidPhoneNumberByCountry(numberStr: "+\(selectedCountryCode )\(collectInfo[Place_Holder.CELL_CONTENT_PHONE.rawValue])") else {
                showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_COUNTRY_BLANK, vc: self)
                return false
            }
        }*/
        guard !collectInfo[Place_Holder.CELL_CONTENT_CONFIRM_PASSWORD.rawValue].isEmpty else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PASSWORD_BLANK, vc: self)
            return false
        }
        guard collectInfo[Place_Holder.CELL_CONTENT_PASSWORD.rawValue] ==  collectInfo[Place_Holder.CELL_CONTENT_CONFIRM_PASSWORD.rawValue] else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PASS_NOT_MATCH, vc: self)
            return false
        }
        if(!isAcceptTermsAndCondition){
            showAlertMessage(title: "Ooops", message: "Please accept terms and condition", vc: self)
            return false
        }
        return true
    }
}

extension SignUpViewController:CustomCountryPickerDelegate{
    
    func GetSelectedCountryNameAndCode(CountryName: String, CountryPhoneCode: String,CountryNameCode: String) {
        selectedCountryName = CountryName
        selectedCountryCode  = CountryPhoneCode
        selectedCountryNameCode = CountryNameCode
        self.tableRegistration.reloadData()
    }
    
    @objc func btnPickerCountrySelection(_ sender: UIButton){
        MyBasics.showCountryPickerDropDown(ParentViewC: self)
      }
    
}
