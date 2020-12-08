//
//  Constant.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation
import UIKit
//Mark : App Data
let App_Title:String! = "Super Mind Skill"
let themeColor:UIColor! = UIColor(red: 119.0/255.0, green: 32.0/255.0, blue: 143.0/255.0, alpha: 1.0)
let placeholderColor:UIColor! = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let appBlueColor:UIColor! = UIColor(red: 0.0/255.0, green: 186.0/255.0, blue: 251.0/255.0, alpha: 1.0)
let appGrayColor:UIColor! = UIColor(red: 59.0/255.0, green: 71.0/255.0, blue: 84.0/255.0, alpha: 1.0)
let deviceBounds:CGRect! = UIScreen.main.bounds
//MARK : AppDelegate instant
let appDel = UIApplication.shared.delegate as! AppDelegate

//MARK : UserDefault
let userDefault = UserDefaults.standard
enum userDefaultKeys: String {
    case userName = "save_user_name"
    case password = "save_Password_name"
    
}



let APP_NAME = ""
let APP_DATE_FORMET = ""

//MARK:  Color section
let APP_THEAM_COLOUR = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)


//MARK:  Constent URl section
let Base_URl = URL(string: "")
let BASE_ImageURl = URL(string: "")


//MARK:  Appdelegate global reference
let AppDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)


//MARK: Alert button title
let ALERT_OK_BUTTON = "OK"
let ALERT_CANCEL_BUTTON = "Cancel"
let ALERT_SUBMIT_BUTTON = "Submit"

var objUser:ModelUser!
var objUserProfile:ModelUserProfile!

///Mark: API
//let BaseUrl:String   =  "https://hypnosis.fitser.com/wp-content/themes/Selfhypnosis/API/"
let BaseUrl:String   =  "https://supermindskill.com/wp-content/themes/Selfhypnosis/API/"

public enum API:Int {
    case registration
    case login
    case otpresend
    case otpvalidate
    case forgetPassword
    case changePassword
    case dashBoardData
    case updateProfile
    case getProfile
    case UpdateProfileImage
    case musicList
    case logoutApi
    case supportApi
    case getPurchase
    case inapp
    func getURL() -> URL? {
        switch self {
            
        case .registration:
            return URL.init(string: (BaseUrl+"ws-reg-otp.php"))
        case .login:
            return URL.init(string: (BaseUrl+"ws-login.php"))
        case .otpresend:
            return URL.init(string: (BaseUrl+"ws-resend.php"))
        case .otpvalidate:
            return URL.init(string: (BaseUrl+"ws-registration.php"))
        case .forgetPassword:
            return URL.init(string: (BaseUrl+"ws-forgotpassword.php"))
        case .changePassword:
            return URL.init(string: (BaseUrl+"ws-password-change.php"))
        case .dashBoardData:
            return URL.init(string: (BaseUrl+"ws-homepage.php"))
        case .updateProfile:
            return URL.init(string: (BaseUrl+"ws-update-personal-info.php"))
        case .getProfile:
            return URL.init(string: (BaseUrl+"ws-view-profile.php"))
        case .UpdateProfileImage:
            return URL.init(string: (BaseUrl+"ws-profileimage.php"))
        case .musicList:
            return URL.init(string: (BaseUrl+"ws-music.php"))
            
        case .logoutApi:
            return URL.init(string: (BaseUrl+"ws-logout.php"))
        case .supportApi:
            return URL.init(string: (BaseUrl+"ws-pagecontent.php"))
        case .getPurchase:
            return URL.init(string: (BaseUrl+"ws-get-purchase.php"))
        case .inapp:
            return URL.init(string: (BaseUrl+"ws-inapp.php"))
        }
    }
    
    
}

extension UITextField {
    
    func addLeftViewPadding(padding:CGFloat, placeholderText: String?){
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        if placeholderText != nil {
            self.attributedPlaceholder = NSAttributedString(string: placeholderText!, attributes: [NSAttributedString.Key.foregroundColor:placeholderColor!])
        }
    }
    
}


extension UITextView: UITextViewDelegate {
    
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0//self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height + 5
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0//self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
    
    
}


extension UIView {
    
    func setRoundCorner(cornerRadious:CGFloat) {
        
        self.layer.cornerRadius = cornerRadious
        self.layer.masksToBounds = true
        
    }
    
    func setBorder(width:CGFloat, borderColor:UIColor, cornerRadious:CGFloat) {
        
        self.layer.cornerRadius = cornerRadious
        self.layer.borderWidth = width
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
        
    }
    
    func animateOpacity() {
        
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(pulseAnimation, forKey: "animateOpacity")
        
    }
    
    
}


var listV = ListPickerView()
var dtPickerView = DatePickerView()
var countryPicView = CountryPickerView()
var shadowView = UIView()

class MyBasics: NSObject {
    
    
    class func showPopup(Title:String?, Message:String?, InViewC:UIViewController?) {
        
        let popUpAlert = UIAlertController(title: Title!, message: Message!, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        popUpAlert.addAction(okAction)
        InViewC?.present(popUpAlert, animated: true, completion: nil)
        
    }
    class func isValidPhoneNumberByCountry(numberStr:String) -> Bool {
        
        let PHONE_REGEX = "^\\+(?:[0-9] ?){10,11}[0-9]$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: numberStr)
        return result
    }
    class func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    class func isValidPhoneNumber(numberStr:String) -> Bool {
        
        let PHONE_REGEX = "^[0-9]{10,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: numberStr)
        return result
    }
    class func isValidCardNumber(numberStr:String,selectedCard:String) -> Bool {
        
        let type = CardType.init(rawValue:selectedCard)
        guard let CARD_REGEX = type?.regex else { return false }//numberStr
        let cardTest = NSPredicate(format: "SELF MATCHES %@", CARD_REGEX)
        let result =  cardTest.evaluate(with: numberStr)
        return result
    }
    class func isPasswordValid(passwordStr : String) -> Bool
    {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$&*%^&~ ]).{8,}$")
        return passwordTest.evaluate(with: passwordStr)
    }
    
    
    class func removeHTMLTag(sourceStr:String!) -> String {
        return sourceStr.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    class func ShowLoginAlert(parentVC:UIViewController) {
        
        let loginAlert = UIAlertController(title: App_Title, message: "Please login to proceed", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            
            parentVC.navigationController?.pushViewController((parentVC.storyboard?.instantiateViewController(withIdentifier: "ViewController"))!, animated: true)
            
        }
        loginAlert.addAction(cancelAction)
        loginAlert.addAction(okAction)
        parentVC.present(loginAlert, animated: true, completion: nil)
        
    }
    
    class func heightForText(text:String!, viewWidth:CGFloat, font:UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: viewWidth, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height + 4
    }
    

    
    // MARK: List picker
    
    class func showListDropDown(Items:Array<String>, ParentViewC:UIViewController) {
        
        shadowView = UIView(frame: deviceBounds)
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.0
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideListView))
        tapGes.numberOfTapsRequired = 1
        shadowView.addGestureRecognizer(tapGes)
        listV = Bundle.main.loadNibNamed("ListPickerView", owner: ParentViewC, options: nil)?.first as! ListPickerView
        listV.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
        ParentViewC.view.addSubview(shadowView)
        ParentViewC.view.addSubview(listV)
        ParentViewC.view.endEditing(true)
        listV.myDelegate = ParentViewC as? CustomListDelegate
        listV.ReloadPickerView(dataArray: Items)
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.3
            listV.frame = CGRect(x: 0, y: deviceBounds.size.height - 227.0, width: deviceBounds.size.width, height: 227.0)
            
        }, completion: nil)
        
    }
 
    @objc class func hideListView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.0
            listV.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
            
        }) { (Bool) in
            
            //listV.myDelegate?.ListDidHide!()
            shadowView.removeFromSuperview()
            listV.removeFromSuperview()
            
        }
    }
    
     
     // MARK: Date picker
    
    class func showDatePickerDropDown(PickerType:UIDatePicker.Mode, ParentViewC:UIViewController) {
        
        shadowView = UIView(frame: deviceBounds)
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.0
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideDatePickerView))
        tapGes.numberOfTapsRequired = 1
        shadowView.addGestureRecognizer(tapGes)
        dtPickerView = Bundle.main.loadNibNamed("ListPickerView", owner: ParentViewC, options: nil)?[1] as! DatePickerView
        dtPickerView.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
        dtPickerView.dtPicker.datePickerMode = PickerType
        ParentViewC.view.addSubview(shadowView)
        ParentViewC.view.addSubview(dtPickerView)
        ParentViewC.view.endEditing(true)
        dtPickerView.delegate = ParentViewC as? DatePickerDelegate
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.3
            dtPickerView.frame = CGRect(x: 0, y: deviceBounds.size.height - 227.0, width: deviceBounds.size.width, height: 227.0)
            
        }, completion: nil)
        
    }
   
    @objc class func hideDatePickerView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.0
            dtPickerView.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
            
        }) { (Bool) in
            
            //listV.myDelegate?.ListDidHide!()
            shadowView.removeFromSuperview()
            dtPickerView.removeFromSuperview()
            
        }
    }
    
    // MARK: Country picker
     
    class func showCountryPickerDropDown(ParentViewC:UIViewController){
        
        shadowView = UIView(frame: deviceBounds)
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0.0
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideCountryPicker))
        tapGes.numberOfTapsRequired = 1
        shadowView.addGestureRecognizer(tapGes)
        countryPicView = Bundle.main.loadNibNamed("ListPickerView", owner: ParentViewC, options: nil)?[2] as! CountryPickerView
        countryPicView.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
        ParentViewC.view.addSubview(shadowView)
        ParentViewC.view.addSubview(countryPicView)
        ParentViewC.view.endEditing(true)
        countryPicView.myDelegate = ParentViewC  as? CustomCountryPickerDelegate
        countryPicView.ReloadCountryPickerView()
        UIView.animate(withDuration: 0.3, animations: {
            
            shadowView.alpha = 0.3
            countryPicView.frame = CGRect(x: 0, y: deviceBounds.size.height - 227.0, width: deviceBounds.size.width, height: 227.0)
            
        }, completion: nil)
        
    }
    
     @objc class func hideCountryPicker() {
         
         UIView.animate(withDuration: 0.3, animations: {
             
             shadowView.alpha = 0.0
             countryPicView.frame = CGRect(x: 0, y: deviceBounds.size.height, width: deviceBounds.size.width, height: 227.0)
             
         }) { (Bool) in
             
             //listV.myDelegate?.ListDidHide!()
             shadowView.removeFromSuperview()
             countryPicView.removeFromSuperview()
             
         }
     }
     

}
enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay,Diners_Carte_Blanche,Visa_Electron
    
    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay,Diners_Carte_Blanche,Visa_Electron]
    
    var regex : String {
        switch self {
        case .Amex:
            return "^3[47][0-9]{5,}$"
        case .Visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
            return "^(5[1-5][0-9]{14}|2(22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))$"
        case .Diners:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
            return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
            return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        case .Diners_Carte_Blanche:
            return "^30[0-5]"
        case .Visa_Electron:
            return "^(4026|417500|4508|4844|491(3|7))"
        default:
            return ""
        }
    }
}
