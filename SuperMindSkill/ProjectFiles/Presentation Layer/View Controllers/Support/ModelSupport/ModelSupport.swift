//
//  ModelSupport.swift
//  SuperMindSkill
//
//  Created by Dipika on 06/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation
struct ModelSupportAll : Codable {
    let model_faq : ModelSupport?
    let model_about_us : ModelSupport?
    let model_privacy_policy : ModelSupport?
    let model_terms_condition : ModelSupport?
    enum CodingKeys: String, CodingKey {

        case model_faq = "faq"
        case model_about_us = "about-us"
        case model_privacy_policy = "privacy-policy"
        case model_terms_condition = "terms-condition"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        model_faq = try values.decodeIfPresent(ModelSupport.self, forKey: .model_faq)
        model_about_us = try values.decodeIfPresent(ModelSupport.self, forKey: .model_about_us)
        model_privacy_policy = try values.decodeIfPresent(ModelSupport.self, forKey: .model_privacy_policy)
        model_terms_condition = try values.decodeIfPresent(ModelSupport.self, forKey: .model_terms_condition)
    }

}
struct ModelSupport : Codable {
    let page_title : String?
    let page_content : String?
 
    enum CodingKeys: String, CodingKey {

        case page_title = "page_title"
        case page_content = "page_content"
    
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page_title = try values.decodeIfPresent(String.self, forKey: .page_title)
        page_content = try values.decodeIfPresent(String.self, forKey: .page_content)

    }

}

class supportModel{
    var supportModelIns :ModelSupportAll?
    internal func logoutApiCall(complitionHandeler:@escaping(_ status: Int, _ message : String ) -> ()){

    
                      
        let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        let operation = WebServiceOperation.init((API.logoutApi.getURL()?.absoluteString ?? ""), nil, .WEB_SERVICE_MULTI_PART, blankMultipart)
        operation.completionBlock = {
            print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
            DispatchQueue.main.async {
                guard let dictResponse = operation.responseData?.dictionary, dictResponse.count > 0 else {
                    //let param:[String:String] = [String:String]()
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                guard let dictStatus = dictResponse["status"] as? [String:Any], dictStatus.count > 0 else {
                    //let param:[String:String] = [String:String]()
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                
                guard let strMsg = dictStatus["message"] as? String else {
                    //let param:[String:String] = [String:String]()
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
                guard let statusCode = dictStatus["error_code"] as? NSNumber else {
                    //let param:[String:String] = [String:String]()
                    complitionHandeler(1, ALERT_MESSAGE_WRONG)
                    return
                }
              if statusCode.intValue == 0 {
//                    guard let dictResult = dictResponse["result"] as? [String:Any], dictResult.count > 0 else {
//                        return
//                    }
                   
                          //  objUser = try JSONDecoder().decode(ModelUser.self, from: dataUserDetails)
                            //print(objUser)
                            complitionHandeler(0, ALERT_MESSAGE_WRONG)
                            
                        
                  
                }else{
                
                    //let param:[String:String] = [String:String]()
                    complitionHandeler(statusCode.intValue, strMsg)
                
                   
                }
                
            }
        }
        
        appDel.operationQueue.addOperation(operation)
    }
    internal func supportApiCall(complitionHandeler:@escaping(_ status: Int, _ message : String) -> ()){
        
        let blankMultipart : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()
        let operation = WebServiceOperation.init((API.supportApi.getURL()?.absoluteString ?? ""), nil, .WEB_SERVICE_MULTI_PART, blankMultipart)
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
                            self.supportModelIns = try JSONDecoder().decode(ModelSupportAll.self, from: dataUserDetails)
                            print(self.supportModelIns!)
                            complitionHandeler(0, ALERT_MESSAGE_WRONG)
                        }catch _ {
                            complitionHandeler(1, strMsg)
                        }
                    }
                 }else{
                   
                    complitionHandeler(1, strMsg)
                    
                }
                
            }
        }
        
        appDel.operationQueue.addOperation(operation)
    }
}
