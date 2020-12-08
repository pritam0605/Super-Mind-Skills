//
//  InitialViewController.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//


import UIKit

import UIKit
import SideMenu
import IQKeyboardManagerSwift
class BaseViewController: UIViewController, UITextFieldDelegate {
    
   
    @IBOutlet var vwHeader:CustomNavigation?
    let refreshControl = UIRefreshControl()
    
    
    var vwLoader = LoaderView(frame: CGRect(x: 0.0, y: 0.0, width: Double(deviceBounds.width), height: Double(deviceBounds.height)))
    @objc   override func viewDidLoad() {
        super.viewDidLoad()
          vwLoader.vwActivity.type = .ballClipRotatePulse
        // Do any additional setup aft@objc @objc er loading the view.
         SideMenuManager.default.leftMenuNavigationController?.settings.presentationStyle = .menuSlideIn
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func fetchRecordedData(){
        let vc = self.storyboard?.instantiateViewController(identifier: "RecordingTitleVC") as! RecordingTitleVC
          self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    
    //MARK: - Internal Methods -
    func showLoading() {
        self.view.isUserInteractionEnabled = false
        vwLoader.startLoading()
        navigationController?.view.addSubview(vwLoader)
    }
    func hideLoading() {
        self.view.isUserInteractionEnabled = true
        vwLoader.removeFromSuperview()
        vwLoader.stopLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //textField.returnKeyType = .done
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func forceLogout()  {
        /*
        UD.removeObject(forKey: SAVE_USER_INFO)
        
        let rootViewController = appDel.window!.rootViewController as! UINavigationController
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        rootViewController.pushViewController(viewController, animated: true)
        */
      
    }
    
    func getFileFromDocumentDirectory(fileName: String) ->  URL {
        let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directoryURL.appendingPathComponent(fileName)
    }
    
    

    
    //keyboard
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        
        let movementDuration:TimeInterval = 0.5
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    internal func moveToLoginScreen() {
        //let vc = LoginVC.init(nibName: "LoginVC", bundle: nil)
       // (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers = [vc]
    }
    
    //MARK: Shadow on view
    func makeShadowToView(shadowView:UIView)
    {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: -0.5, height: 1)
        shadowView.layer.shadowRadius = 1
        
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shouldRasterize = true
    }
    func makeShadowToChildView(shadowView:UIView)
    {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0))
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 4
    }
    //Mark: Resizing Image
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        //let rect =  CGSize(width: newSize.width * heightRatio, height: newSize.height)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        //CGRectMake(0, 0, newSize.width, newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        //image.drawInRect(rect)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func dateFormatterFlexible(strDate:String, fromDateFromat:String, toDateFormat:String)->String
    {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        
        dateFormatter.dateFormat = fromDateFromat//"dd-MM-yyyy hh:mm a"
        guard let date = dateFormatter.date(from: strDate) else {
            return strDate
        }
        //let date = try dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = toDateFormat//"hh:mm a"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        //print("EXACT_DATE : \(dateString)")
        return dateString
    }
    func convertUnixToFormattedDateTime(needFormat:String,timeResult:String) -> String{
        
        guard let timeResultDouble = Double(timeResult) else { return timeResult }
        let date = Date(timeIntervalSince1970: timeResultDouble)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = needFormat
        
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}

extension BaseViewController {
   
    func calculateAge(birthday: String) -> Int{
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = ""
        guard let birthdayDate = dateFormater.date(from: birthday) else {
            return 0
        }
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components(.year, from: birthdayDate, to: now as Date, options: [])
        guard let age = calcAge.year else { return 0 }
        return age
        
    }
    func calculateAgeByFull(birthday: String,DateFormat:String) -> String{
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormat
        
        var birthdayDate = Date()
        if let birthdayDateTemp = dateFormater.date(from: birthday) {
            birthdayDate = birthdayDateTemp
        }else{
            dateFormater.dateFormat = "MMMM dd, yyyy"
            if let birthdayDateTemp = dateFormater.date(from: birthday) {
               birthdayDate = birthdayDateTemp
            }else{
                return "0"
            }
        }
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components([.year, .month, .day], from: birthdayDate, to: now as Date, options: [])
        
        guard let age_yr = calcAge.year else { return "0" }
        guard let age_mn = calcAge.month else { return "0" }
        guard let age_dt = calcAge.day else { return "0" }
        
        let age = "\(age_yr)" + " " + "Years" + ", " + "\(age_mn)" + " " + "Months" + ", " + "\(age_dt)" + " " + "Days"
        return age
        
    }
    func isValidAge(birthday: String,DateFormat:String) ->Bool {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DateFormat
        
        var birthdayDate = Date()
        if let birthdayDateTemp = dateFormater.date(from: birthday) {
            birthdayDate = birthdayDateTemp
        }else{
            dateFormater.dateFormat = "MMMM dd, yyyy"
            if let birthdayDateTemp = dateFormater.date(from: birthday) {
                birthdayDate = birthdayDateTemp
            }
            else
            {
                dateFormater.dateFormat = "dd-MM-YYYY"
                if let birthdayDateTemp = dateFormater.date(from: birthday) {
                   birthdayDate = birthdayDateTemp
                }else{
                    dateFormater.dateFormat = "YYYY-MM-dd"
                    if let birthdayDateTemp = dateFormater.date(from: birthday) {
                       birthdayDate = birthdayDateTemp
                    }
                }
            }
        }
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components([.year, .month, .day], from: birthdayDate, to: now as Date, options: [])
        
        guard let age_yr = calcAge.year else { return false }
        if(age_yr >= 18){
            return true
        }
        return false
    }
}

extension BaseViewController {
   //Common function
    func deletAndSave(arr:[ModelRecordData], index: Int)  {
        var array = arr
        array.remove(at: index)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: array)
        UserDefaults.standard.set(encodedData, forKey: "FinalSound")
        UserDefaults.standard.synchronize()
    }
}



