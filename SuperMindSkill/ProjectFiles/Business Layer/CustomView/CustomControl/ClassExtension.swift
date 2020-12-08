//
//  LoginVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    func makeButtonCornerRadius(){
       let radius = (self.frame.size.height / 2)
           self.layer.cornerRadius = radius
           self.clipsToBounds = true
       }
}

extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }

}
extension String {

    func changeColorForNumbers() -> NSMutableAttributedString {
        //let purple = [NSAttributedString.Key.foregroundColor: themeColor]
        //let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]

        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.boldSystemFont(ofSize: 17.0), NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : themeColor ?? UIColor.purple]
        
        let myAttributedString = NSMutableAttributedString()
        for letter in self.unicodeScalars {
            let myLetter : NSAttributedString
            if CharacterSet.decimalDigits.contains(letter) {
                myLetter = NSAttributedString(string: "\(letter)", attributes: attributes)
               
            } else {
                myLetter = NSAttributedString(string: "\(letter)")
            }
            myAttributedString.append(myLetter)
        }

        return myAttributedString
    }

}

extension String {
    
    var roundOfPrice: String {
        
        let charset = CharacterSet(charactersIn: ".")
        if self.rangeOfCharacter(from: charset) != nil {
           return  self.components(separatedBy: ".").first ?? ""
        }else{
            return self
        }
        
      
           
    }
   
    var trimSpace: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isValidTenDigitMobileNumber : Bool{
       let p = self.trimSpace
        return p.count >= 10 ? true : false
    }
    
    func toDate(withFormate formet: String) -> Date? {
        let dateFormatter = DateFormatter()
        //let utcTimeZone = TimeZone(secondsFromGMT: 0)
        //dateFormatter.timeZone = utcTimeZone
        dateFormatter.dateFormat = formet
        let date = dateFormatter.date(from: self)
        return date
    }
    
    var isValideEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPhoneNumberCountryWise: Bool{
        let PHONE_REGEX = "^\\+(?:[0-9] ?){10,11}[0-9]$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return  phoneTest.evaluate(with: self)
        
    }
   // MARK: -  PasswordValidation(Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
    var isPasswordValidation: Bool{
         let Password_REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
           let Password = NSPredicate(format: "SELF MATCHES %@", Password_REGEX)
           return  Password.evaluate(with: self)
          
       }
    
    //
    
    var containsDigits : Bool {
        return (self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil)
    }
}

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
extension UINavigationController {
    //Mark:  - Check in navigation stack
    func containsViewController(ofKind kind: AnyClass) -> Bool {
        return self.viewControllers.contains(where: {$0.isKind(of: kind)})
    }
    //function use to check whether that VC is in the Stack or not , if in tha stack tha pop or Push
    func popPushToVC(ofKind Kind: AnyClass, pushController: UIViewController) {
        if containsViewController(ofKind: Kind) {
            for controller in self.viewControllers{
                if controller.isKind(of: Kind){
                    popToViewController(controller, animated: true)
                    break
                }
            }
        } else{
            pushViewController(pushController, animated: true)
        }
    }
    
    func popToVC(ofKind Kind: AnyClass) {
          if containsViewController(ofKind: Kind) {
              for controller in self.viewControllers{
                  if controller.isKind(of: Kind){
                      popToViewController(controller, animated: true)
                      break
                  }
              }
          }
      }
    func removeAviewControllerFromStack(ofKind Kind: AnyClass) {
             if containsViewController(ofKind: Kind) {
                 for controller in self.viewControllers{
                     if controller.isKind(of: Kind){
                        controller.removeFromParent()
                         break
                     }
                 }
             }
         }
    
    func backToPreviousPage() {
      self.popViewController(animated: true)
        
    }
    
}
extension UIView {
    func makeRound(){
    let radius = (self.frame.size.width / 2) 
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func makeRoundCornerRadius(){
    let radius = (self.frame.size.height / 2)
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
   
}


extension Date {
 
    func afterMonth(getMonth:Int) -> Date{
        return Calendar.current.date(byAdding: .month, value: getMonth, to: noon)!
    }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    static var nextMonth:  Date { return Date().monthAfter }
    static var nextyear:  Date { return Date().yearAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var monthAfter: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: noon)!
    }
    var yearAfter: Date {
        return Calendar.current.date(byAdding: .year, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
         default:
              break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}







extension Data {
    
    var dictionary:[String:Any]? {
        do{
            if let json = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:Any] {
                return json
            }
        }catch let e {
            print(e.localizedDescription)
            return nil
        }
        return nil
    }
}


extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var prettyprintedJSON: String? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
    var data:Data? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


//Pritam Added 
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let purchaseSuccess = Notification.Name("purchaseSuccess")
    static let purchaseFail = Notification.Name("purchaseFail")
    static let stopLoader = Notification.Name("stopLoader")
    
}




