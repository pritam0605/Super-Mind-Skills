//
//  LoginModel.swift
//  SuperMindSkill
//
//  Created by Dipika on 04/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation


class loginModelClass {
    
    internal func loginApiCall(email:String,passsword:String, complitionHandeler:@escaping(_ status: Int, _ message : String, _ dictResult:[String:String] ) -> ()){
        
        var param:[String:AnyObject] = [String:AnyObject]()
        param["email"] = email as AnyObject
        param["password"] = passsword as AnyObject
        //print(param)
    
                      
        let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        let operation = WebServiceOperation.init((API.login.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
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
                    guard let dictUserDetails = dictResult["details"] as? [String:Any], dictUserDetails.count > 0 else {
                        return
                    }
                    if let dataUserDetails = dictUserDetails.data, dataUserDetails.count > 0 {
                        do{
                            objUser = try JSONDecoder().decode(ModelUser.self, from: dataUserDetails)
                            
                            //// SAVE USER DATA
                            if let userid = objUser.strUserId {
                                UserDefaults.standard.set(userid, forKey: "USERID")
                            }
                            if let trialMode = objUser.trial_mode {
                                if trialMode == "expired"{
                                    UserDefaults.standard.set(trialMode, forKey: "ISLive")
                                
                                }
                            }
                            //Pritam
                            if let userEmail = objUser.strEmail {
                                                           UserDefaults.standard.set(userEmail, forKey: "USEREMAIL")
                                                       }
                            complitionHandeler(0, ALERT_MESSAGE_WRONG, param as! [String : String])
                        }catch let _ {
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
    internal func forgetPasswordApiCall(email:String, complitionHandeler:@escaping(_ status: Int, _ message : String, _ dictResult:[String:String] ) -> ()){
           
           var param:[String:AnyObject] = [String:AnyObject]()
           param["email"] = email as AnyObject
          
                         
           let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
           let operation = WebServiceOperation.init((API.forgetPassword.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
           operation.completionBlock = {
               print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
               
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
           
           appDel.operationQueue.addOperation(operation)
       }
    
    
    internal func ChangetPasswordApiCall(password:String, email:String, complitionHandeler:@escaping(_ status: Int, _ message : String, _ dictResult:[String:String] ) -> ()){
        
        var param:[String:AnyObject] = [String:AnyObject]()
        param["email"] = email as AnyObject
        param["new_password"] = password as AnyObject
        
         let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        
        let operation = WebServiceOperation.init((API.changePassword.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
        operation.completionBlock = {
            print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
            
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
        
        appDel.operationQueue.addOperation(operation)
    }
       
}
