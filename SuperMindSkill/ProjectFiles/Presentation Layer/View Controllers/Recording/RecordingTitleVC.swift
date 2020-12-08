//
//  RecordingTitleVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 30/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class RecordingTitleVC: BaseViewController  {
    @IBOutlet var customTabbar:CustomVerticalTabbarView!
    
    @IBOutlet var txtGoal:UITextField!
    @IBOutlet var txtTitle:UITextField!
    @IBOutlet var btnGoal:UIButton!
    @IBOutlet var btnNext:UIButton!
    var objRecordData:ModelRecordData!
    var savedAllRecording = [ModelRecordData]() // new line
    
    
   var arrTitle = ["Absolute", "Access", "Accomplished", "Accountable", "Accurate", "Acting", "Advanced", "Affirmation", "Airplane", "Anxiety", "Apprehensive", "Appropriate", "Assured", "Astonishing", "Attitude", "Authentic", "Automatic", "Awesome", "Best", "Better", "Bigger", "Birthday", "Brilliant", "Carefree", "Children", "Clients", "Clothing", "Co-ordinated", "Comfortable", "Complete", "Country Life", "Customers", "Definite", "Dependable", "Different", "Drinking", "Easter", "Eating", "Ecstatic", "Effortless", "Elated", "Entertainment", "Everlasting", "Exams", "Excellent", "Exercise", "Exiting", "Fabulous", "Fantastic", "Focused", "Food", "Friendship", "Genuine", "Grateful", "Gym", "Happy", "Healthy", "Holiday", "Important", "Improvement", "Income", "Incredible", "Insecurity", "Instructive", "Instructive", "Interesting", "Interesting", "Internet Business", "Kiss", "Laughter", "Learning", "Longterm", "Love", "Magnificent", "Marriage", "Memorable", "Money", "Motor Vehicle", "Music", "Passionate", "Pleasant", "Reach", "Real Estate", "Relationships", "Remarkable", "Rewarding", "Safe", "Sales Success", "Security", "Self Improvement", "Shelter", "Simplistic", "Smoking", "Sport", "Study", "Success", "Supportive", "Tangible", "Target", "Teach", "Terrific", "Tough", "Travel", "Unique", "wealthy", "Weight Loss", "Wise", "Xmas"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwHeader?.lableTitle.text = "TITLE"
        self.vwHeader?.headerType = .back
        self.navigationController?.removeAviewControllerFromStack(ofKind: MemeberShipVC.self)
        tabbarUISetup()
        btnGoal.setTitleColor(.lightGray, for: .normal)
         print("Array before count  ******", arrTitle.count)
        let p = arrTitle.sorted{$0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        print("Array name after shor ******", p)
        print("Array name after sort count ******", p.count)
        
        /// get recording permission
        RecorderClass.shared.requestForRecordPermission()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRecordDemographicData()
    }
   
    func tabbarUISetup(){
        ///// Call Custom Tabbar
        customTabbar.setup(activeFor:"Title")
        customTabbar.myDelegate = self
        makeShadowToChildView(shadowView: customTabbar)
        self.view.bringSubviewToFront(customTabbar)
    }
  
    func fetchRecordDemographicData(){
        do {
            if let data = UserDefaults.standard.data(forKey: "USER_AUDIO_MERGED_RECORD_DATA"),
                let arrDataUnsavedResult = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ModelRecordData
            {
                objRecordData = arrDataUnsavedResult
                
                
                btnGoal.setTitle(objRecordData.Goal, for: .normal)
                btnGoal.setTitleColor(.black, for: .normal)
                self.txtTitle.text = objRecordData.Title
            }else{
               objRecordData = ModelRecordData(Goal: "" , Title: "", Description: "", recordUrl: "", selectedMusicUrl: "", selectedMusicTitle: "")
            }
        }catch{
            
        }
    }

}
extension RecordingTitleVC:CustomVerticalTabbarDelegate {
    func GetSelectedIndex(Index: Int) {
        if(Index == 1){
        }
        else if(Index == 2){
            moveToNext() //misic
        }else if(Index == 3){
            moveToRecordings() // recording
        }else if(Index == 4){
            moveToSave()
        }
    }
}
extension RecordingTitleVC{
    func moveToNext(){
        objRecordData.Goal = btnGoal.titleLabel?.text ?? ""
        objRecordData.Title = txtTitle.text ?? ""
        if(isValidation(model: objRecordData)){
            self.saveInLocalObject()
            let vc = self.storyboard?.instantiateViewController(identifier: "MusicVC") as! MusicVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - SAVE tempurary data -
    func saveInLocalObject()  {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: objRecordData!)
        UserDefaults.standard.set(encodedData, forKey: "USER_AUDIO_MERGED_RECORD_DATA")
        UserDefaults.standard.synchronize()
    }
    

    
    func moveToRecordings(){
        if(isValidation(model: objRecordData)){
        guard !self.objRecordData.selectedMusicUrl.isEmpty else {
            showAlertMessage(title: "Ooops", message: "Please Select a music", vc: self)
            return
        }
        self.saveInLocalObject()
        let vc = self.storyboard?.instantiateViewController(identifier: "RecordingVC") as! RecordingVC
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func moveToSave(){
        if(isValidation(model: objRecordData)){
        guard !self.objRecordData.recordUrl.isEmpty else {
            showAlertMessage(title: "Ooops", message: "Please record somethings", vc: self)
            return
        }
        
        if let totalSaveArray =    UserDefaults.standard.data(forKey: "FinalSound") {
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: totalSaveArray) as! [ModelRecordData]
            self.savedAllRecording.removeAll()
            self.savedAllRecording = decodedTeams
        }
        self.savedAllRecording.append(self.objRecordData!)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.savedAllRecording)
        UserDefaults.standard.set(encodedData, forKey: "FinalSound")
        UserDefaults.standard.synchronize()

        let vc = self.storyboard?.instantiateViewController(identifier: "AffirmationViewController") as! AffirmationViewController
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
   
    
    @IBAction func buttonDidtapNext(_ sender: UIButton){}
    
    
    func isValidation(model:ModelRecordData) -> Bool {
        guard !model.Goal.isEmpty else {
            showAlertMessage(title: "Ooops", message: "Please give goal", vc: self)
            return false
        }
        
        return true
    }
    
    
}
extension RecordingTitleVC:CustomListDelegate{
    @IBAction func buttonPickerSelection(_ sender: UIButton){
        MyBasics.showListDropDown(Items: arrTitle, ParentViewC: self)
    }
    func GetSelectedPickerItemIndex(Index: Int){
        //txtGoal.text = arrTitle[Index]
        btnGoal.setTitle(arrTitle[Index], for: .normal)
        if  arrTitle[Index] != "" {
        self.objRecordData.Goal = arrTitle[Index]
        }
        
        btnGoal.setTitleColor(.black, for: .normal)
    }
}
