//
//  SupportVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 31/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class SupportVC: BaseViewController {
    @IBOutlet var customTabbar:CustomTabbarView!
    @IBOutlet var tableSupport:UITableView!
    let modelsupport =  supportModel()
    var isRowOpenedSet = [false,false,false,false,false,false]
    var arrSectionHeader = ["FAQ","Contact","About","Privacy Policy","Terms & Conditions","Change Password"]
    
    
    var supportData = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.vwHeader?.lableTitle.text = "SUPPORT"
        self.vwHeader?.headerType = .back
        
        ///// Call Custom Tabbar
        tabbarUISetup()
        ////Call Support Api
        callSupportApi()
    }
    
    func tabbarUISetup(){
        ///// Call Custom Tabbar
        customTabbar.setup(activeFor:"Support")
        customTabbar.myDelegate = self
        makeShadowToChildView(shadowView: customTabbar)
    }
    func callSupportApi() {
        modelsupport.supportApiCall{(status,msg) in
            if(status == 0){
                 self.tableSupport.reloadData()
            }
        }
    }
    
    @objc func btnLogoutPressed(_ sender:UIButton){
        let alertController = UIAlertController(title: App_Title, message: "Are you sure, you want to logout?", preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.logoutApiCall()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }

        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK:LOGOUT API CALL
    
    func logoutApiCall(){
       modelsupport.logoutApiCall{(status,msg) in
            if (status == 0){
                UserDefaults.standard.removeObject(forKey: "USERID")
             
                 let vc = self.storyboard?.instantiateViewController(identifier: "InitialViewController") as! InitialViewController
                self.navigationController?.popPushToVC(ofKind:InitialViewController.self , pushController:vc )
              
        }
      }
    }
}


extension SupportVC:CustomTabbarDelegate{
    func GetSelectedIndex(Index: Int) {
        print(Index)
        if(Index == 1){
            let vc = self.storyboard?.instantiateViewController(identifier: "DashBoardVC") as! DashBoardVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(Index == 2){
           fetchRecordedData()
        }else if(Index == 3){
            let vc = self.storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 4){
          
        }else if(Index == 5){
            let vc = self.storyboard?.instantiateViewController(identifier: "AffirmationViewController") as! AffirmationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension SupportVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isRowOpenedSet[section] == true ? 1 : 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let indexPath = IndexPath(row: 0, section: section)
        let cell: CommonCellTableViewCell = self.tableSupport.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell1", for: indexPath as IndexPath)as! CommonCellTableViewCell

        cell.lblHeader.text = arrSectionHeader[section]
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        if(isRowOpenedSet[section]){
            cell.btnInstance.setImage(UIImage(named:"DownArrow"), for: .normal)
            cell.lblSeparator.isHidden = true
        }else{
            cell.btnInstance.setImage(UIImage(named:"arrowRight"), for: .normal)
            cell.lblSeparator.isHidden = false
        }
        /////// use for drop down
        cell.btnInstance.tag = section
        cell.btnInstance.addTarget(self, action: #selector(openOrCloseRow), for: .touchUpInside)
        
        cell.btnOverAll.tag = section
        cell.btnOverAll.addTarget(self, action: #selector(openOrCloseRow), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 1){//Contact
            let cell: CommonCellTableViewCell = self.tableSupport.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell3") as! CommonCellTableViewCell
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.btnInstance.tag = indexPath.section
            cell.btnInstance.addTarget(self, action: #selector(openOrCloseRow), for: .touchUpInside)
            return cell
        }
        else if(indexPath.section == 2){// About
            let cell: CommonCellTableViewCell = self.tableSupport.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell4") as! CommonCellTableViewCell
            cell.lblHeader.isHidden = true
            cell.lblInfo.attributedText = modelsupport.supportModelIns?.model_about_us?.page_content?.htmlToAttributedString
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.btnInstance.tag = indexPath.section
            cell.btnInstance.addTarget(self, action: #selector(openOrCloseRow), for: .touchUpInside)
            return cell
        }else if(indexPath.section == 5){// About
        let cell: CommonCellTableViewCell = self.tableSupport.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell4") as! CommonCellTableViewCell
        cell.lblHeader.isHidden = true
        cell.lblInfo.text = ""
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.btnInstance.tag = indexPath.section
        cell.btnInstance.addTarget(self, action: #selector(openOrCloseRow), for: .touchUpInside)
        return cell
        }
        
        
        else{//FAQ
            let cell: CommonCellTableViewCell = self.tableSupport.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell4") as! CommonCellTableViewCell
            
            cell.lblHeader.isHidden = true
            if indexPath.section == 0 {
                 cell.lblInfo.attributedText = modelsupport.supportModelIns?.model_faq?.page_content?.htmlToAttributedString
            }else if  indexPath.section == 3{
                 cell.lblInfo.attributedText = modelsupport.supportModelIns?.model_privacy_policy?.page_content?.htmlToAttributedString
            }else{
                 cell.lblInfo.attributedText = modelsupport.supportModelIns?.model_terms_condition?.page_content?.htmlToAttributedString
            }

            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.btnInstance.tag = indexPath.section
            cell.btnInstance.addTarget(self, action: #selector(openOrCloseRow), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 5 ? 90 : 0 //4 ? 90 : 0
    }
    
    
    //Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(section == 5){
            let indexPath = IndexPath(row: 0, section: section)
            let cell: CommonCellTableViewCell = self.tableSupport.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell2", for: indexPath as IndexPath)as! CommonCellTableViewCell
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.lblHeader.text = self.version()
            cell.btnInstance.addTarget(self, action: #selector(btnLogoutPressed(_:)), for: .touchUpInside)
            
            return cell
        }else{return nil}
    }
}


extension SupportVC{
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "Version: \(version)"
    }
    
    @objc func openOrCloseRow(_ sender: UIButton){
        if sender.tag == 0 || sender.tag == 2{
            let vc = self.storyboard?.instantiateViewController(identifier: "FAQViewController") as! FAQViewController
            vc.pageName = (sender.tag == 0) ? "FAQ":"ABOUT US"
            self.navigationController?.pushViewController(vc, animated: true)
        } else   if sender.tag == 5 {
            let vc = self.storyboard?.instantiateViewController(identifier: "ChangePassword") as! ChangePassword
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            isRowOpenedSet[sender.tag] = !isRowOpenedSet[sender.tag]
            tableSupport.reloadData()
        }
    }
}
