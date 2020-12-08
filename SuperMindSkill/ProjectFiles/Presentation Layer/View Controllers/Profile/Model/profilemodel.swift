//
//  profilemodel.swift
//  SuperMindSkill
//
//  Created by Dipika on 04/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation

class modelProfileClass{
    internal func apiForGetProfile( userid:String, complitionHandeler:@escaping(_ status: Int, _ message : String, _ dictResult:[String:String]) -> ()){
        
        var param:[String:AnyObject] = [String:AnyObject]()
        param["user_id"] = userid as AnyObject
        
        
        let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        let operation = WebServiceOperation.init((API.getProfile.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
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
                    //guard let dictUserDetails = dictResult["details"] as? [String:Any], dictUserDetails.count > 0 else {
                    //   return
                    // }
                    if let dataUserDetails = dictResult.data, dataUserDetails.count > 0 {
                        do{
                            objUserProfile = try JSONDecoder().decode(ModelUserProfile.self, from: dataUserDetails)
                            print(objUserProfile)
                            complitionHandeler(0, ALERT_MESSAGE_WRONG, param as! [String : String])
                            
                        }catch let e {
                            complitionHandeler(1, strMsg, param as! [String : String])
                            
                        }
                    }
                }else{
                    let param:[String:String] = [String:String]()
                    complitionHandeler(statusCode.intValue, strMsg,param)
                }
                
            }
        }
        
        appDel.operationQueue.addOperation(operation)
    }
    
    internal func apiForUpdateProfile( userid:String,
                                       firstname:String,
                                       lastname:String,
                                       country_code:String,
                                       mobile:String,
                                       address:String,
                                       postcode:String,
                                       city:String,
                                       nationality:String,
                                       company:String,
                                       complitionHandeler:@escaping(_ status: Int, _ message : String, _ dictResult:[String:String]) -> ()){
        
        var param:[String:AnyObject] = [String:AnyObject]()
        param["user_id"] = userid as AnyObject
        param["firstname"] = firstname as AnyObject
        param["lastname"] = lastname as AnyObject
        param["country_code"] = country_code as AnyObject
        param["mobile"] = mobile as AnyObject
        param["address"] = address as AnyObject
        param["postcode"] = postcode as AnyObject
        param["city"] = city as AnyObject
        param["nationality"] = nationality as AnyObject
        param["company"] = company as AnyObject
        
        let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        let operation = WebServiceOperation.init((API.updateProfile.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
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
                    complitionHandeler(0, strMsg, param as! [String : String])
                }else{
                    let param:[String:String] = [String:String]()
                    complitionHandeler(statusCode.intValue, strMsg,param)
                }
            }
        }
        
        appDel.operationQueue.addOperation(operation)
    }
    
    
    internal func apiForUpdateProfileimage( userid:String,imageFileInfo:[MultiPartDataFormatStructure], complitionHandeler:@escaping(_ status: Int, _ message : String) -> ()){
        
        var param:[String:AnyObject] = [String:AnyObject]()
        param["user_id"] = userid as AnyObject
        print(param)
        
        let operation = WebServiceOperation.init((API.UpdateProfileImage.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, imageFileInfo)
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
                    
                    if let dataUserDetails = dictResult.data, dataUserDetails.count > 0 {
                        do{
                           
                            complitionHandeler(0, strMsg)
                            
                        }catch  {
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
}

