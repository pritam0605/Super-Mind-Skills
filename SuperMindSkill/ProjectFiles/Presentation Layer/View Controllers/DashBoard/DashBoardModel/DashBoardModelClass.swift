//
//  DashBoardModelClass.swift
//  SuperMindSkill
//
//  Created by Abhik on 10/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation
struct ModelDashBoard : Codable {
    let banner_list : [ModelBannerList]?
    let affirmation_list : [ModelAffirmationList]?
  
    enum CodingKeys: String, CodingKey {

        case banner_list = "banner_list"
        case affirmation_list = "affirmation_list"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        banner_list = try values.decodeIfPresent([ModelBannerList].self, forKey: .banner_list)
        affirmation_list = try values.decodeIfPresent([ModelAffirmationList].self, forKey: .affirmation_list)
    }
}
struct ModelBannerList : Codable {
    let banner_id : Int?
    let banner_title : String?
    let banner_image : String?
    
    enum CodingKeys: String, CodingKey {
        
        case banner_id = "banner_id"
        case banner_title = "banner_title"
        case banner_image = "banner_image"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        banner_id = try values.decodeIfPresent(Int.self, forKey: .banner_id)
        banner_title = try values.decodeIfPresent(String.self, forKey: .banner_title)
        banner_image = try values.decodeIfPresent(String.self, forKey: .banner_image)
        
    }
    
}
struct ModelAffirmationList : Codable {
    let aff_id : Int?
    let aff_title : String?
    let aff_description : String?
    
    enum CodingKeys: String, CodingKey {
        
        case aff_id = "aff_id"
        case aff_title = "aff_title"
        case aff_description = "aff_description"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aff_id = try values.decodeIfPresent(Int.self, forKey: .aff_id)
        aff_title = try values.decodeIfPresent(String.self, forKey: .aff_title)
        aff_description = try values.decodeIfPresent(String.self, forKey: .aff_description)
    }
    
}
class DashBoardModelClass {
    var dashBoardData : ModelDashBoard?
    internal func apiForFetchingDashBoardData(complitionHandeler:@escaping(_ status: Int, _ message : String) -> ()){
        
        let operation = WebServiceOperation.init((API.dashBoardData.getURL()?.absoluteString ?? ""), nil, .WEB_SERVICE_GET)
        operation.completionBlock = {
            //print(operation.responseData?.dictionary?.prettyprintedJSON ?? "")
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
                    guard let dictUserDetails = dictResponse["result"] as? [String:Any], dictUserDetails.count > 0 else {
                        return
                    }
                   
                    if let dataUserDetails = dictUserDetails.data, dataUserDetails.count > 0 {
                        do{
                            self.dashBoardData = try JSONDecoder().decode(ModelDashBoard.self, from: dataUserDetails)
                            print(self.dashBoardData)
                            
                            complitionHandeler(0, strMsg)
                        }catch _ {
                            complitionHandeler(1, ALERT_MESSAGE_WRONG)
                            
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
