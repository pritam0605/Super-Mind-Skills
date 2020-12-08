//
//  RegistrationModel.swift
//  WorldPeaceArtProgram
//
//  Created by Pritamranjan Dey on 16/10/19.
//  Copyright © 2019 Rupbani. All rights reserved.
//

import Foundation
import UIKit

struct ModelUserProfile : Codable {
    let nationality : String?
    let profile_pic_url : String?
    let mobile : String?
    let user_login : String?
    let postcode : String?
    let user_id : String?
    let company : String?
    let address : String?
    let first_name : String?
    let user_email : String?
    let city : String?
    let last_name : String?
    let country_code : String?

    enum CodingKeys: String, CodingKey {

        case nationality = "nationality"
        case profile_pic_url = "profile_pic_url"
        case mobile = "mobile"
        case user_login = "user_login"
        case postcode = "postcode"
        case user_id = "user_id"
        case company = "company"
        case address = "address"
        case first_name = "first_name"
        case user_email = "user_email"
        case city = "city"
        case last_name = "last_name"
        case country_code = "country_code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
        profile_pic_url = try values.decodeIfPresent(String.self, forKey: .profile_pic_url)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        user_login = try values.decodeIfPresent(String.self, forKey: .user_login)
        postcode = try values.decodeIfPresent(String.self, forKey: .postcode)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        user_email = try values.decodeIfPresent(String.self, forKey: .user_email)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
    }

}
struct ModelUser: Codable{

    let profile_pic_url : String?
    let strUserLogin : String?
    let strEmail : String?
    let country_code : String?
    let user_id : Int?
    let company : String?
    let city : String?
    let strFamilyName : String?
    let user_pass : String?
    let user_url : String?
    let nationality : String?
    let user_registered : String?
    let user_nicename : String?
    let strMobile : String?
    let user_status : String?
    let strUserId : String?
    let display_name : String?
    let password : String?
   
    let strFirstName : String?
    let strAddress : String?
    let pin : String?
    let trial_mode: String?

    enum CodingKeys: String, CodingKey {

        case profile_pic_url = "profile_pic_url"
        case strUserLogin = "user_login"
        case strEmail = "user_email"
        case country_code = "country_code"
        case user_id = "user_id"
        case company = "company"
        case city = "city"
        case strFamilyName = "last_name"
        case user_pass = "user_pass"
        case user_url = "user_url"
        case nationality = "nationality"
        case user_registered = "user_registered"
        case user_nicename = "user_nicename"
        case strMobile = "mobile"
        case user_status = "user_status"
        case strUserId = "ID"
        case display_name = "display_name"
        case password = "password"
        case trial_mode = "trial_mode"
        case strFirstName = "first_name"
        case strAddress = "address"
        case pin = "postcode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profile_pic_url = try values.decodeIfPresent(String.self, forKey: .profile_pic_url)
        strUserLogin = try values.decodeIfPresent(String.self, forKey: .strUserLogin)
        strEmail = try values.decodeIfPresent(String.self, forKey: .strEmail)
        country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        strFamilyName = try values.decodeIfPresent(String.self, forKey: .strFamilyName)
        user_pass = try values.decodeIfPresent(String.self, forKey: .user_pass)
        user_url = try values.decodeIfPresent(String.self, forKey: .user_url)
        nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
        user_registered = try values.decodeIfPresent(String.self, forKey: .user_registered)
        user_nicename = try values.decodeIfPresent(String.self, forKey: .user_nicename)
        strMobile = try values.decodeIfPresent(String.self, forKey: .strMobile)
        user_status = try values.decodeIfPresent(String.self, forKey: .user_status)
        strUserId = try values.decodeIfPresent(String.self, forKey: .strUserId)
        display_name = try values.decodeIfPresent(String.self, forKey: .display_name)
        password = try values.decodeIfPresent(String.self, forKey: .password)
       
        strFirstName = try values.decodeIfPresent(String.self, forKey: .strFirstName)
        strAddress = try values.decodeIfPresent(String.self, forKey: .strAddress)
        pin = try values.decodeIfPresent(String.self, forKey: .pin)
        trial_mode = try values.decodeIfPresent(String.self, forKey: .trial_mode)
    }

}


class registrationModelClass {
   
    internal func apiForRegistration( firstname:String,lastname: String,  email: String, mobile: String, password: String,country_code:String,complitionHandeler:@escaping(_ status: Int, _ message : String, _ dictResult:[String:String]) -> ()){
        
        var param:[String:AnyObject] = [String:AnyObject]()
        param["firstname"] = firstname as AnyObject
        param["lastname"] = lastname as AnyObject
        
        param["email"] = email as AnyObject
        param["mobile"] = mobile as AnyObject
        
        
        param["password"] = password as AnyObject
        param["country_code"] = country_code as AnyObject
                      
        let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        let operation = WebServiceOperation.init((API.registration.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
        operation.completionBlock = {
            print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
            DispatchQueue.main.async {
                guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                    let param:[String:String] = [String:String]()
                    complitionHandeler(1, ALERT_MESSAGE_WRONG,param)
                    return
                }
                guard let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0 else {
                    let param:[String:String] = [String:String]()
                    complitionHandeler(1, ALERT_MESSAGE_WRONG,param)
                    return
                }
                
                guard let strMsg = dictStatus["message"] as? String else {
                    let param:[String:String] = [String:String]()
                    complitionHandeler(1, ALERT_MESSAGE_WRONG,param)
                    return
                }
                guard let statusCode = dictStatus["error_code"] as? NSNumber else {
                    let param:[String:String] = [String:String]()
                    complitionHandeler(1, ALERT_MESSAGE_WRONG,param)
                    return
                }
                if statusCode.intValue == 0 {
                    guard let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0 else {
                        return
                    }
                    var param:[String:String] = [String:String]()
                    param["email"] = dictResult["email"] as? String
                    param["otp"] = String(dictResult["otp"] as! Int)
                    
                    
                    complitionHandeler(0, strMsg,param)
                    
                }else{
                    let param:[String:String] = [String:String]()
                    complitionHandeler(statusCode.intValue, strMsg,param)
                   
                }
                
            }
        }
        
        appDel.operationQueue.addOperation(operation)
    }
    
    internal func apiForOTPValidation(email: String, otp: String,complitionHandeler:@escaping(_ status: Int, _ message : String) -> ()){
          
          var param:[String:AnyObject] = [String:AnyObject]()
          param["email"] = email as AnyObject
          param["otp"] = otp as AnyObject
    
          let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
          let operation = WebServiceOperation.init((API.otpvalidate.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
          operation.completionBlock = {
              print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
            DispatchQueue.main.async {
                guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                    
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                guard let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0 else {
                    
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                
                guard let strMsg = dictStatus["message"] as? String else {
                    
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                guard let statusCode = dictStatus["error_code"] as? NSNumber else {

                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                if statusCode.intValue == 0 {
                    guard let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0 else {
                        return
                    }
                    guard let dictUserDetails = dictResult["details"] as? [String:Any], dictUserDetails.count > 0 else {
                        return
                    }
                    if let dataUserDetails = dictUserDetails.data, dataUserDetails.count > 0 {
                        do{
                            objUser = try JSONDecoder().decode(ModelUser.self, from: dataUserDetails)
                            complitionHandeler(0, ALERT_MESSAGE_WRONG)
                            
                        }catch _ {
                            complitionHandeler(1, strMsg)
                            
                        }
                    }
                }else{
                    
                    complitionHandeler(statusCode.intValue, strMsg)
                    
                }
                
            }
          }
          
          appDel.operationQueue.addOperation(operation)
      }
       internal func apiForResendOtp(email: String,complitionHandeler:@escaping(_ status: Int, _ message : String, _ dictResult:[String:String]) -> ()){
             
             var param:[String:AnyObject] = [String:AnyObject]()
            
             param["email"] = email as AnyObject
           
             let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
             let operation = WebServiceOperation.init((API.otpresend.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
             operation.completionBlock = {
                 print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
                 DispatchQueue.main.async {
                     guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                         let param:[String:String] = [String:String]()
                         complitionHandeler(1, ALERT_MESSAGE_WRONG,param)
                         return
                     }
                     guard let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0 else {
                         let param:[String:String] = [String:String]()
                         complitionHandeler(1, ALERT_MESSAGE_WRONG,param)
                         return
                     }
                     
                     guard let strMsg = dictStatus["message"] as? String else {
                         let param:[String:String] = [String:String]()
                         complitionHandeler(1, ALERT_MESSAGE_WRONG,param)
                         return
                     }
                     guard let statusCode = dictStatus["error_code"] as? NSNumber else {
                         let param:[String:String] = [String:String]()
                         complitionHandeler(1, ALERT_MESSAGE_WRONG,param)
                         return
                     }
                     if statusCode.intValue == 0 {
                         guard let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0 else {
                             return
                         }
                         var param:[String:String] = [String:String]()
                         param["email"] = dictResult["email"] as? String
                         param["otp"] = String(dictResult["otp"] as! Int)
                         
                         
                         complitionHandeler(0, strMsg,param)
                         
                     }else{
                         let param:[String:String] = [String:String]()
                         complitionHandeler(statusCode.intValue, strMsg,param)
                        
                     }
                     
                 }
             }
             
             appDel.operationQueue.addOperation(operation)
         }
}
