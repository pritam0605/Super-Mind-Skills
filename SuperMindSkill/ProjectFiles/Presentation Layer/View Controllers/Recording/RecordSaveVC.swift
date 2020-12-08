//
//  RecordSaveVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 30/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import AVKit
class RecordSaveVC: BaseViewController {
    var savedPath = URL(string: "")
    var objRecordData4:ModelRecordData?
    var savedAllRecording = [ModelRecordData]() // new line
    @IBOutlet var customTabbar:CustomVerticalTabbarView!
    @IBOutlet var txtGoal:UITextField!
    @IBOutlet var txtTitle:UITextField!
    @IBOutlet var txtTitleLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwHeader?.lableTitle.text = "SAVE"
        self.vwHeader?.headerType = .back
        // Do any additional setup after loading the view.
        ///// Call Custom Tabbar
        
        tabbarUISetup()
        showSavedRecordData()
    }
    func showSavedRecordData(){
        self.txtGoal.text = objRecordData4?.Goal
        self.txtGoal.textAlignment = .center
        self.txtTitle.text = objRecordData4?.Title
        self.txtTitle.textAlignment = .center
        self.txtTitleLabel.isHidden = (objRecordData4?.Title == "") ? true : false
    }
    
    @IBAction func buttonPressDeleteRecord(_ sender: UIButton) {
        self.objRecordData4?.recordUrl = ""
      self.navigationController?.popViewController(animated: true)
    }
    func tabbarUISetup(){
        ///// Call Custom Tabbar
        customTabbar.setup(activeFor:"Save")
        customTabbar.myDelegate = self
        makeShadowToChildView(shadowView: customTabbar)
    }
    override func viewDidDisappear(_ animated: Bool) {
        //////stop backgroundMusic
        MusicPlayer.shared.stopBackgroundMusic()
        ///Stop Micro Phone
        RecorderClass.shared.endRecord()
    }
}
extension RecordSaveVC:CustomVerticalTabbarDelegate {
    func GetSelectedIndex(Index: Int) {
        print(Index)
        if(Index == 1){
            let vc = self.storyboard?.instantiateViewController(identifier: "RecordingTitleVC") as! RecordingTitleVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(Index == 2){
            let vc = self.storyboard?.instantiateViewController(identifier: "MusicVC") as! MusicVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 3){
            let vc = self.storyboard?.instantiateViewController(identifier: "RecordingVC") as! RecordingVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 4){
            
        }
    }
}
extension RecordSaveVC{
    @IBAction func buttonDidtapNext(_ sender: UIButton){
        // have to save global
        if let totalSaveArray =    UserDefaults.standard.data(forKey: "FinalSound") {
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: totalSaveArray) as! [ModelRecordData]
            self.savedAllRecording.removeAll()
        self.savedAllRecording = decodedTeams
        }
         self.savedAllRecording.append(self.objRecordData4!)
        
        
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.savedAllRecording)
        UserDefaults.standard.set(encodedData, forKey: "FinalSound")
        UserDefaults.standard.synchronize()
        
        
        let vc = self.storyboard?.instantiateViewController(identifier: "DashBoardVC") as! DashBoardVC
        self.navigationController?.popPushToVC(ofKind: DashBoardVC.self, pushController: vc)
    }
    
    
    
    @IBAction func buttonDidtapSavedAudioPlay(_ sender: UIButton){
        if(!sender.isSelected){
            if let mergeAudioURLStr = self.objRecordData4?.recordUrl {

                print(mergeAudioURLStr)
                let mergeAudioURL = self.getFileFromDocumentDirectory(fileName: mergeAudioURLStr)
                DispatchQueue.global(qos: .background).async {
                    MusicPlayer.shared.startBackgroundMusicPlayBySession(musicMurl:mergeAudioURL)
                }
            }
          
        }else{
            MusicPlayer.shared.pauseBackgroundMusic()
        }
        sender.isSelected = !sender.isSelected
    }
}

