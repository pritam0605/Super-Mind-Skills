//
//  InAppModel.swift
//  SuperMindSkill
//
//  Created by Pritam Dey on 24/04/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation
enum enPurchaseType: Int {
    case logeIn = 3
    case trial // on trial
    case trialExpire // if  trialExpire only membership will show
    case membership // on membership
    case membershipExpire   // if  membershipExpire only membership will show
 
   
}

enum enEnableType: Int {
    case NoMembership // if  for newUser only both membership will show
    case Expire // if  trialExpire only membership will show
    case OnMmbership // on membership // full access
 
    
}

class ModelInAppPurchase {
    func detailsOfInAppPurchase(userID:String, complitionHandeler:@escaping(_ status: Int, _ message : String ) -> ()){
        
        var param:[String:AnyObject] = [String:AnyObject]()
        param["user_id"] = userID as AnyObject
        
        
        let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        let operation = WebServiceOperation.init((API.getPurchase.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
        operation.completionBlock = {
            print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
            
            guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                
                complitionHandeler(1, ALERT_MESSAGE_WRONG)
                return
            }
            guard let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0 else {
                
                complitionHandeler(1, ALERT_MESSAGE_WRONG)
                return
            }
            
            
            guard let statusCode = dictStatus["error_code"] as? NSNumber else {
                
                complitionHandeler(1, ALERT_MESSAGE_WRONG)
                return
            }
            if statusCode.intValue == 0 {
                guard let result =  dictResponse["result"] as? [String:Any], dictStatus.count > 0 else{
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                guard let details =  result["details"] as? [String:Any], dictStatus.count > 0 else{
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                if let  purchaseType: String = details["purchase_type"] as?  String{
                    
                    if purchaseType == "Membership"{ 
                        if details["purchase_status"] as? String == "active"{ // baki
                            complitionHandeler(enPurchaseType.membership.rawValue, "")
                        }else{
                            //user dafult
                            complitionHandeler(enPurchaseType.membershipExpire.rawValue, "")
                        }
                        
                    }else if purchaseType == "Trial" {
                        if details["purchase_status"] as? String == "expired"{ // baki
                            //user dafult
                            complitionHandeler(enPurchaseType.trialExpire.rawValue, "")
                        }else{
                            complitionHandeler(enPurchaseType.trial.rawValue, "")
                        }
                        
                    }else {
                        complitionHandeler(enPurchaseType.logeIn.rawValue, "") // loged in but not buy any things

                    }
                }else{
                complitionHandeler(1, ALERT_MESSAGE_WRONG)
                }
            }else{
                
                complitionHandeler(statusCode.intValue, "")
                
            }
            
        }
        
        appDel.operationQueue.addOperation(operation)
    }
    
    
    
    
    func UpdateInAppPurchase(userID:String, purchaseType: String, complitionHandeler:@escaping(_ status: Int, _ message : String ) -> ()){
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        var param:[String:AnyObject] = [String:AnyObject]()
        param["user_id"] = userID as AnyObject
        param["purchase_type"] = purchaseType as AnyObject
        param["device_type"] = "1" as AnyObject
        param["purchase_receipt"] = recieptString as AnyObject
        print("param== %@",param)
        
        let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        let operation = WebServiceOperation.init((API.inapp.getURL()?.absoluteString ?? ""), param, .WEB_SERVICE_MULTI_PART, blankMultipart)
        operation.completionBlock = {
            print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
            
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
                complitionHandeler(0, strMsg)
            }else{
                let param:[String:String] = [String:String]()
                complitionHandeler(statusCode.intValue, strMsg)
            }
        }
        appDel.operationQueue.addOperation(operation)
    }
}
