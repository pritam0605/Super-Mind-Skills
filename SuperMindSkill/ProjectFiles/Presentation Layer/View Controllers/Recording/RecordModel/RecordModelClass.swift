//
//  RecordModelClass.swift
//  SuperMindSkill
//
//  Created by Abhik on 06/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation


class  ModelRecordData: NSObject,NSCoding {

    var Goal: String
    var Title: String
    var Description: String
    var recordUrl: String
    var selectedMusicUrl: String
    var selectedMusicTitle: String
    
    init(Goal: String,Title: String,Description: String,recordUrl: String, selectedMusicUrl: String,selectedMusicTitle: String  ) {
        self.Goal = Goal
        self.Title = Title
        self.Description = Description
        self.recordUrl = recordUrl
        self.selectedMusicUrl = selectedMusicUrl
        self.selectedMusicTitle = selectedMusicTitle
       
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Goal, forKey: "Goal")
        aCoder.encode(Title, forKey: "Title")
        aCoder.encode(Description, forKey: "Description")
        aCoder.encode(recordUrl, forKey: "recordUrl")
        aCoder.encode(selectedMusicUrl, forKey: "selectedMusicUrl")
        aCoder.encode(selectedMusicTitle, forKey: "selectedMusicTitle")
    }
    
      
      required init(coder decoder: NSCoder) {
          self.Goal = decoder.decodeObject(forKey: "Goal") as? String ?? ""
          self.Title = decoder.decodeObject(forKey: "Title") as? String ?? ""
          self.Description = decoder.decodeObject(forKey: "Description") as? String ?? ""
          self.recordUrl = decoder.decodeObject(forKey: "recordUrl") as? String ?? ""
          self.selectedMusicUrl = decoder.decodeObject(forKey: "selectedMusicUrl") as? String ?? ""
          self.selectedMusicTitle = decoder.decodeObject(forKey: "Description") as? String ?? ""
      }
      

}


struct ModelMusicList : Codable {
    let music_list : [ModelMusic]?
    enum CodingKeys: String, CodingKey {
      case music_list = "music_list"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        music_list = try values.decodeIfPresent([ModelMusic].self, forKey: .music_list)
        
    }
}


struct ModelMusic : Codable {
    let music_id : Int?
    let music_title : String?
    let music_description : String?
    let music_url : String?
    enum CodingKeys: String, CodingKey {
        
        case music_id = "music_id"
        case music_title = "music_title"
        case music_description = "music_description"
        case music_url = "music_url"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        music_id = try values.decodeIfPresent(Int.self, forKey: .music_id)
        music_title = try values.decodeIfPresent(String.self, forKey: .music_title)
        music_description = try values.decodeIfPresent(String.self, forKey: .music_description)
        music_url = try values.decodeIfPresent(String.self, forKey: .music_url)
    }
    
}

class  SelectedModelRecordData: NSObject, NSCoding {
   let music_id : Int?
   let music_title : String?
   let music_description : String?
   let music_url : String?
    init(music_id: Int,music_title: String,music_description: String,music_url: String) {
        self.music_id = music_id
        self.music_title = music_title
        self.music_description = music_description
        self.music_url = music_url
       
    }
    required init(coder decoder: NSCoder) {
        self.music_id = decoder.decodeObject(forKey: "music_id") as? Int ?? 0
        self.music_title = decoder.decodeObject(forKey: "music_title") as? String ?? ""
        self.music_description = decoder.decodeObject(forKey: "music_description") as? String ?? ""
        self.music_url = decoder.decodeObject(forKey: "music_url") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(music_id, forKey: "music_id")
        coder.encode(music_title, forKey: "music_title")
        coder.encode(music_description, forKey: "music_description")
        coder.encode(music_url, forKey: "music_url")
    }
}
class RecordModelClass{
    var musicList : ModelMusicList?
    internal func apiForFetchingMusicList(complitionHandeler:@escaping(_ status: Int, _ message : String) -> ()){
        
        let operation = WebServiceOperation.init((API.musicList.getURL()?.absoluteString ?? ""), nil, .WEB_SERVICE_GET)
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
                            self.musicList = try JSONDecoder().decode(ModelMusicList.self, from: dataUserDetails)
                            print(self.musicList!)
                            
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



