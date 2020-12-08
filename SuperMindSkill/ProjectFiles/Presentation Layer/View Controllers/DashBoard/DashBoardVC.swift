//
//  DashBoardVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 29/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import Kingfisher
class DashBoardVC: BaseViewController {
    @IBOutlet var customTabbar:CustomTabbarView!
    @IBOutlet var tableDashBoard:UITableView!
    var slides:[Slide] = [];
    var userCurrentSubsCription: enEnableType?
    var savedRecording = [ModelRecordData]()
    let modelDashBoard =  DashBoardModelClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.vwHeader?.lableTitle.text = "HOME"
        //self.vwHeader?.headerType = .back
        self.vwHeader?.btnLeft.isHidden = true
        self.vwHeader?.imageLeft.isHidden = true
        tableDashBoard.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callDashBoardApi()
        tabbarUISetup()
        UserDefaults.standard.removeObject(forKey: "USER_AUDIO_MERGED_RECORD_DATA")
        UserDefaults.standard.removeObject(forKey: "selectedIndexForMusic")
        fetchRecordDemographicData()
    }
    
    func showPurchasePopupOnrecordButton(){ // noly Show popup case
        if (appDel.userCurrentSubsCription != enEnableType.OnMmbership) { 
            
            
            showAlertMessageWithActionButton(title: App_Title, message: "Before continuing to Record you have to purchase a package among the list. If you agree please press ok." , actionButtonText: "OK", cancelActionButtonText: "Cancel", vc: self) { (status) -> (Void) in
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
            self.fetchRecordedData()
        }
    }


    func callDashBoardApi() {
        modelDashBoard.apiForFetchingDashBoardData{(status,msg) in
            if(status == 0){
                //print(self.modelDashBoard.dashBoardData?.affirmation_list)
            }
            self.tableDashBoard.isHidden = false
            self.tableDashBoard.reloadData()
        }
    }
    //MARK: Get Recorded List
    func fetchRecordDemographicData(){
        savedRecording.removeAll()
        do {
            if let decoded  =  UserDefaults.standard.data(forKey: "FinalSound") {
                let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ModelRecordData]
                savedRecording.removeAll()
                savedRecording = decodedTeams
                
            }
       }
      
    }
  
  
    
    func tabbarUISetup(){
        customTabbar.setup(activeFor:"Home")
        customTabbar.myDelegate = self
        makeShadowToChildView(shadowView: customTabbar)
    }
    
}
/**
 Mark: Custom Tabbar Navigation work
 */

//MARK: Tab bar
extension DashBoardVC: CustomTabbarDelegate{
    func GetSelectedIndex(Index: Int) {
        print(Index)
        if(Index == 1){
           
        }else if(Index == 2){
            self.showPurchasePopupOnrecordButton()
        }else if(Index == 3){
            let vc = self.storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 4){
            let vc = self.storyboard?.instantiateViewController(identifier: "SupportVC") as! SupportVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 5){
            let vc = self.storyboard?.instantiateViewController(identifier: "AffirmationViewController") as! AffirmationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension DashBoardVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){ // Image slider Call
            let cell: CommonCellTableViewCell = self.tableDashBoard.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell3") as! CommonCellTableViewCell
            let blankBannerList =  [ModelBannerList]()
            slides = createSlidesBanner(bannerList: self.modelDashBoard.dashBoardData?.banner_list ?? blankBannerList)
            
            cell.scrollView.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: 150)
            cell.scrollView.contentSize = CGSize(width: (CGFloat(self.modelDashBoard.dashBoardData?.banner_list?.count ?? 0) * cell.frame.size.width), height: cell.scrollView.frame.size.height)
            cell.setupSlideScrollView(slides: slides,parentSize:CGSize(width: cell.contentView.frame.size.width, height: 150))
            cell.scrollView.delegate = self
            cell.pageController.numberOfPages = (self.modelDashBoard.dashBoardData?.banner_list?.count ?? 0)
            cell.pageController.currentPage = 0
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.contentView.contentMode = .scaleAspectFill
            cell.scrollView.contentMode = .scaleAspectFill
            return cell
        }
            
        else {
            
            let cell: CommonCellTableViewCell = self.tableDashBoard.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell1", for: indexPath as IndexPath)as! CommonCellTableViewCell
            if  indexPath.row == 0 {
                cell.lblHeader.text = "F.A.Q."
                cell.lblInfo.text = "Understanding Super Mind Skill"
                
                cell.selectionStyle = .none
               // cell.imgContent.isHidden = true
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                makeShadowToChildView(shadowView: cell.vwContainer)
                // return cell
                
            }else if indexPath.row == 1{
                cell.lblHeader.text = "ABOUT"
                cell.lblInfo.text = "" //"Tap for ABOUT"
                //cell.gapConstrain.constant = 0
                cell.selectionStyle = .none
                //cell.imgContent.isHidden = true
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                makeShadowToChildView(shadowView: cell.vwContainer)
                
            } else if indexPath.row == 2{
                cell.lblHeader.text = "YOUR LIBARY OF RECORDED AFFIRMATION"//"RECORDED AFFIRMATION"
                //cell.lblInfo.text = "Tap for recording"
                cell.lblInfo.text = ""
              
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                makeShadowToChildView(shadowView: cell.vwContainer)
                // return cell
            }else{
                
                cell.lblHeader.text = ""
                let txtInfo = " Super Mind Skill \n Life changing \n 1.Record your Affirmation in your own voice  \n 2.Choose music  \n 3.Train your subconscious \n to be happy healthy wise & wealthy"
                let  finalText = txtInfo.changeColorForNumbers()
               
                cell.lblInfo.numberOfLines = 0
                cell.selectionStyle = .none
                //cell.imgContent.isHidden = true
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                makeShadowToChildView(shadowView: cell.vwContainer)
                cell.btnInstance.isHidden = true
                 cell.lblInfo.attributedText = finalText
               
            }
            return cell
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if indexPath.section == 1 {
        if indexPath.row == 0 || indexPath.row == 1{
          let vc = self.storyboard?.instantiateViewController(identifier: "FAQViewController") as! FAQViewController
            vc.pageName = indexPath.row == 0 ? "FAQ": "ABOUT US"
          self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc = self.storyboard?.instantiateViewController(identifier: "AffirmationViewController") as! AffirmationViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        }

    }
}
///Mark : Slide Work
extension DashBoardVC{
    func createSlidesBanner(bannerList:[ModelBannerList]) -> [Slide] {
        var arrSlide = [Slide]()
        for (_,object) in bannerList.enumerated(){
            let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            let url = URL(string: object.banner_image ?? "")
            slide1.imageView.kf.setImage(with: url)
            arrSlide.append(slide1)
        }
        return arrSlide
    }
    func createSlidesTemp(imageArray:[String]) -> [Slide] {
        var arrSlide = [Slide]()
        for (_,object) in imageArray.enumerated(){
            let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide1.imageView.image = UIImage(named: object)
            arrSlide.append(slide1)
        }
        
        return arrSlide
        
    }
    
}
extension DashBoardVC:UIScrollViewDelegate{
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let index = IndexPath(row: 0, section: 0)
        guard let cell = self.tableDashBoard.cellForRow(at: index) as? CommonCellTableViewCell else {
            return
        }
        
        let pageIndex = round(scrollView.contentOffset.x/tableDashBoard.frame.width)
        cell.pageController.currentPage = Int(pageIndex)

    }
}

