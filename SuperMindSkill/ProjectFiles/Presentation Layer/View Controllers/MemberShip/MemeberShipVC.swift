//
//  MemeberShipVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 29/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class MemeberShipVC: BaseViewController {
    @IBOutlet weak var colVWMember:UICollectionView!
    let inApp = InAppPurchaseClass()
    var prchaseType:String = ""
    var trialModeActiveOrNot:Bool = true
    let model = ModelInAppPurchase()
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.colVWMember.delegate = self
        self.colVWMember.dataSource = self
        if let isLive:String = UserDefaults.standard.value(forKey: "ISLive") as? String {
            if isLive == "expired" {
                trialModeActiveOrNot = false
                self.colVWMember.reloadData()
            }
        }
        
    }
    //In App Purchase
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print(InAppPurchaseClass.share.prices)
        print(inApp.givePiceDetails)
        NotificationCenter.default.addObserver(self, selector: #selector(self.successPurches), name: .purchaseSuccess, object: nil)
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.failedPurches), name: .purchaseFail, object: nil)
        //self.colVWMember.reloadData()
    }
    
    @objc func successPurches(){
        CustomActivityIndicator.sharedInstance.hide {
                      
                   }
         self.updateApi()
    }
    @objc func failedPurches(){
        CustomActivityIndicator.sharedInstance.hide {
                      
                   }
    }

    func updateApi()  {
        let userID:String = UserDefaults.standard.value(forKey: "USERID") as? String ?? ""
        self.model.UpdateInAppPurchase(userID: userID, purchaseType: self.prchaseType) { (status, msg) in
            if status == 0{
                DispatchQueue.main.async {
                    appDel.userCurrentSubsCription = .OnMmbership
                    let vc = self.storyboard?.instantiateViewController(identifier: "RecordingTitleVC") as! RecordingTitleVC
                    self.navigationController?.popPushToVC(ofKind: RecordingTitleVC.self, pushController: vc)
                }
               
            }
        }
    }

   
}
extension MemeberShipVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.trialModeActiveOrNot ? 3 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if(indexPath.row == (self.trialModeActiveOrNot ? 0 : -99)){
            let myCell = colVWMember?.dequeueReusableCell(withReuseIdentifier: "CollectionViewMemeberCell1", for: indexPath) as! CollectionViewMemeberCell
            //7days free
            myCell.contentView.layer.cornerRadius = 10
            myCell.contentView.layer.borderWidth = 1.0
            myCell.contentView.layer.borderColor = UIColor.clear.cgColor
            if InAppPurchaseClass.share.prices.count > 0{
                myCell.lblHeader.text = "\(InAppPurchaseClass.share.prices[0]) for 3 days trial period"
            }
            myCell.btnProceed.tag = indexPath.row
            // myCell.btnProceed.addTarget(self, action: #selector(btnPressedPressed), for: .touchUpInside)
            return myCell
        }else if(indexPath.row ==   (self.trialModeActiveOrNot ? 1 : 0) ){
            let myCell = colVWMember?.dequeueReusableCell(withReuseIdentifier: "CollectionViewMemeberCell4", for: indexPath) as! CollectionViewMemeberCell
            myCell.contentView.layer.cornerRadius = 10
            myCell.contentView.layer.borderWidth = 1.0
            myCell.contentView.layer.borderColor = UIColor.clear.cgColor
            let pro = InAppPurchaseClass.share.products["Met.SuperMindSkill.non_Renewable.TwelveMonthSubscribe"]
            print(pro?.priceLocale.currencySymbol ?? "")
            if InAppPurchaseClass.share.prices.count > 1 {
                myCell.lblHeader.text = "\(InAppPurchaseClass.share.prices[1]) for 12 months subscription"
            }
            myCell.btnProceed.tag = indexPath.row
            return myCell
        } else{
            let myCell = colVWMember?.dequeueReusableCell(withReuseIdentifier: "CollectionViewMemeberCell3", for: indexPath) as! CollectionViewMemeberCell
            myCell.contentView.layer.cornerRadius = 10
            myCell.contentView.layer.borderWidth = 1.0
            myCell.contentView.layer.borderColor = UIColor.clear.cgColor
            return myCell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let val = (colVWMember.frame.size.width - 30)
        var height = 70.0
        if self.trialModeActiveOrNot{
           height = indexPath.row == 2 ? 70.0 : 150.0
        }else{
             height = indexPath.row == 1 ? 70.0 : 150.0
        }
       
        return CGSize(width:val , height:CGFloat(Float(height)))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if(indexPath.row == (self.trialModeActiveOrNot ? 0 : -99)){
            self.prchaseType = "Trial"
            CustomActivityIndicator.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
            }
            InAppPurchaseClass.share.purchase(productID: "Met.SuperMindSkill.SevenDaysTrial")
            
        }else if (indexPath.row ==  (self.trialModeActiveOrNot ? 1 : 0)){
            self.prchaseType = "Membership"
            CustomActivityIndicator.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
            }
            InAppPurchaseClass.share.purchase(productID: "Met.SuperMindSkill.non_Renewable.TwelveMonthSubscribe")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }

    /*
    
    @objc func btnPressedPressed(_ sender: UIButton!){
        if(sender.tag == 0){
             inApp.purchase(productID: "Met.SuperMindSkill.non_Renewable.ThreeDaysSubscribe")
        }
 // In App purchase
        else if (sender.tag == 1){
            inApp.purchase(productID: "Met.SuperMindSkill.non_Renewable.OneYearSubscribe")
            let vc = self.storyboard?.instantiateViewController(identifier: "DashBoardVC") as! DashBoardVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else{
            showAlertMessageWithActionButton(title: "Confirm Your App Purchase \n  for $99", message: "[Environment:SandBox]", actionButtonText: "Buy",cancelActionButtonText: "Cancel", vc: self, complitionHandeler: { (status) -> (Void) in
                if status == 1 {
                    
                }
            })
        }
    }
    */
    
    
}
extension MemeberShipVC{
    @IBAction func navigatForBack(_ sender: UIButton){
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.popViewController(animated: true)
    }
    
    
    
    func showAlert(){
        let alertController = UIAlertController(title: App_Title, message: "You want to Buy or Restore your purchases?", preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "Restore", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            InAppPurchaseClass.share.restorePurchase { (success, getString) in
                if success{
                    //let alert  = UIAlertController(title: "Sucess", message: "Successfully Resored", preferredStyle: .alert)
                    MyBasics.showPopup(Title: "Success", Message: "Your purchases are successfully restored", InViewC: self)
                    
//                   alert.addAction(UIAlertAction)
//                   self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        let buyNow = UIAlertAction(title: "Buy", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
           self.prchaseType = "Membership"
           CustomActivityIndicator.sharedInstance.display(onView: UIApplication.shared.keyWindow) {
                          
            }
            InAppPurchaseClass.share.purchase(productID: "Met.SuperMindSkill.non_Renewable.SixMonthSubscribe")
        }

        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(buyNow)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
  
