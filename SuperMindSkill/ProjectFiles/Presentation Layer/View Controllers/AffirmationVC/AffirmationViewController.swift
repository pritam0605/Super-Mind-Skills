//
//  AffirmationViewController.swift
//  SuperMindSkill
//
//  Created by Pritam on 05/03/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class AffirmationViewController: BaseViewController {
    @IBOutlet weak var affirmationTable:UITableView!
    @IBOutlet weak var viewNoData:UIView!
    @IBOutlet weak var buttonNewRecord:UIButton!
    var arrUserDataRecord = [ModelRecordData]()
    @IBOutlet var customTabbar:CustomTabbarView!
    
    @IBOutlet weak var affimationTableBackGround: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "USER_AUDIO_MERGED_RECORD_DATA")
        UserDefaults.standard.removeObject(forKey: "selectedIndexForMusic")
        self.tabbarUISetup()
    }
    
    
    func tabbarUISetup(){
        ///// Call Custom Tabbar
        customTabbar.setup(activeFor:"Affirmation")
        customTabbar.myDelegate = self
        makeShadowToChildView(shadowView: customTabbar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewNoData.isHidden = true
        //aself.vwHeader?.headerType = .back
        self.vwHeader?.lableTitle.text = "MY LIBARY OF GOALS AND AFFIMATIONS"
        self.vwHeader?.lableTitle.numberOfLines = 0
        self.affirmationTable.isHidden = true
        self.affimationTableBackGround.isHidden = true
        self.vwHeader?.btnLeft.isHidden = true
        self.vwHeader?.imageLeft.isHidden = true
        self.fetchRecordDemographicData()
    }
    
    @IBAction func buttonTapGoToRecord(_ sender: UIButton) {
       self.showPurchasePopupOnrecordButton()
        
    }
    
    
    func showPurchasePopupOnrecordButton(){ // noly Show popup case
        if (appDel.userCurrentSubsCription != enEnableType.OnMmbership) {
               showAlertMessageWithActionButton(title: App_Title, message: "Before continuing to Record you have to purchase a package among the list. If you agree please press ok.", actionButtonText: "OK", cancelActionButtonText: "Cancel", vc: self) { (status) -> (Void) in
                   if status == 1{
                       let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeberShipVC") as! MemeberShipVC
                       if (appDel.userCurrentSubsCription == enEnableType.NoMembership) {
                           ViewController.trialModeActiveOrNot = true
                       }else{
                           ViewController.trialModeActiveOrNot = false
                       }
                       self.navigationController?.pushViewController(ViewController, animated: true)
                   }
               }
           }else{
              let vc = self.storyboard?.instantiateViewController(identifier: "RecordingTitleVC") as! RecordingTitleVC
               self.navigationController?.popPushToVC(ofKind: RecordingVC.self, pushController: vc)
           }
       }
    
    @objc func didTapDeleteRecord(_ sender: UIButton!){
        showAlertMessageWithActionButton(title:"", message: "Do you want to delete your affirmation?", actionButtonText: "YES",cancelActionButtonText: "NO", vc: self, complitionHandeler: { (status) -> (Void) in
            if status == 1 {
                DispatchQueue.main.async {
                    self.deleteItem(index: sender.tag)
                   // UserDefaults.standard.removeObject(forKey: "FinalSound")
                    self.fetchRecordDemographicData()
                }
            }
        })
    }
    
    
    func deleteItem(index: Int){
        if arrUserDataRecord.count > 0 {
            deletAndSave(arr: arrUserDataRecord, index: index)
//            arrUserDataRecord.remove(at: index)
//            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: arrUserDataRecord)
//            UserDefaults.standard.set(encodedData, forKey: "FinalSound")
//            UserDefaults.standard.synchronize()
            fetchRecordDemographicData()
        }
        
        
        
    }
    
    //MARK: Get Recorded List 
    func fetchRecordDemographicData(){
        arrUserDataRecord.removeAll()
        do {
            if let decoded  =  UserDefaults.standard.data(forKey: "FinalSound") {
                let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ModelRecordData]
                arrUserDataRecord.removeAll()
                arrUserDataRecord = decodedTeams
                if arrUserDataRecord.count > 0{
                    self.affirmationTable.isHidden = false
                    self.affimationTableBackGround.isHidden = false
                    self.affimationTableBackGround.isHidden = false
                    self.affirmationTable.reloadData()
                }else{
                    self.affirmationTable.reloadData()
                    self.affimationTableBackGround.isHidden = true
                    self.affimationTableBackGround.isHidden = true
                    self.viewNoData.isHidden = false
                }
            }else{
                self.viewNoData.isHidden = false
                self.affimationTableBackGround.isHidden = true
                self.affimationTableBackGround.isHidden = true
            }
        }

    } 
}

//MARK: Table view delegate and datasource 
extension AffirmationViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrUserDataRecord.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommonCellTableViewCell = self.affirmationTable.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell2") as! CommonCellTableViewCell
        let mdOBJ = arrUserDataRecord[indexPath.row]
        cell.lblHeader.text = mdOBJ.Goal
        cell.lblInfo.text = mdOBJ.Title
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.btnInstance.tag = indexPath.row
        cell.btnInstance.addTarget(self, action: #selector(didTapDeleteRecord(_:)), for: .touchUpInside)
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let decoded  =  UserDefaults.standard.data(forKey: "FinalSound") {
            let decodedTeamsArray = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ModelRecordData]
            if decodedTeamsArray.count > 0 {
            let vc = self.storyboard?.instantiateViewController(identifier: "PlayListViewController") as! PlayListViewController
            vc.model = decodedTeamsArray[indexPath.row]
            vc.selectedIndex = indexPath.row
            vc.arrUserDataRecord = decodedTeamsArray
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
    }
}

extension AffirmationViewController: CustomTabbarDelegate{
    func GetSelectedIndex(Index: Int) {
        print(Index)
        if(Index == 1){
           let vc = self.storyboard?.instantiateViewController(identifier: "DashBoardVC") as! DashBoardVC
           self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 2){
            self.fetchRecordedData()
        }else if(Index == 3){
            let vc = self.storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 4){
            let vc = self.storyboard?.instantiateViewController(identifier: "SupportVC") as! SupportVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 5){
           
        }
    }
}
