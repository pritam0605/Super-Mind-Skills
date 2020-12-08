//
//  InitialViewController.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//
import UIKit
import SideMenu

enum HEADER_TYPE:Int {
    case menu = 0
    case dashboardMenu
    case back
    case whiteBack
    func getImage() -> UIImage {
        switch self {
        case .menu:
            return  UIImage.init(named: "menu")!
        case .dashboardMenu:
            return  UIImage.init(named: "menu")!
        case .back:
            return  UIImage.init(named: "arrowleft")!
        case .whiteBack:
            return  UIImage.init(named: "arrowleft")!
        }
    }
}



class CustomNavigation: UIView {
    fileprivate var view:UIView!
    @IBOutlet var customNavigationView: UIView!
    @IBOutlet weak var navigationCustomContainView: UIView!
    @IBOutlet weak var lableTitle: UILabel!
    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var btnLeft:UIButton!
    @IBOutlet weak var rightButton1:UIButton!
    @IBOutlet weak var rightButton2:UIButton!
     @IBOutlet weak var imgbackGround:UIImageView!
    internal var headerType :HEADER_TYPE = .menu {
        didSet{
             
            switch self.headerType {
            case .menu:
                self.imageLeft.image = self.headerType.getImage()
                self.lableTitle.isHidden = false
                //self.rightButton2.setImage(UIImage(named: "userWhite"), for: .normal)
                self.rightButton1.isHidden = true
                self.rightButton2.isHidden = true
                
                self.lableTitle.textColor = UIColor.white
                break
                
            case .dashboardMenu:
                self.imageLeft.image = self.headerType.getImage()
                 self.lableTitle.isHidden = true
                 self.rightButton2.setImage(UIImage(named: "settingsIcon"), for: .normal)
                break
                
            case .back:
                self.imageLeft.image = self.headerType.getImage()
                self.lableTitle.isHidden = false
                self.rightButton1.isHidden = true
                self.rightButton2.isHidden = true
                
                self.lableTitle.textColor = UIColor.white
                break
                
            case .whiteBack:
                self.imageLeft.image = self.headerType.getImage()
                self.lableTitle.isHidden = false
                self.lableTitle.textColor = UIColor.white
                self.rightButton1.isHidden = true
                self.rightButton2.isHidden = true
                
                break
            }
        }
    }

    
      override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
     }

    internal required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
         setup()
      }

    private convenience init() {
           self.init(frame: CGRect.zero)
       }
    
 
    
    private func setup() {
         if let view = Bundle.main.loadNibNamed("NavigationHeader", owner: self, options: nil)?.first as? UIView {
             self.view = view
            self.view.backgroundColor = UIColor.clear
             self.view.frame = self.bounds
             self.addSubview(self.view)
             
             self.translatesAutoresizingMaskIntoConstraints = false
             self.view.translatesAutoresizingMaskIntoConstraints = false
             
             let consTop = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0)
             consTop.isActive = true
             
             let consRight = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0.0)
             consRight.isActive = true
             
             let consBottom = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0)
             consBottom.isActive = true
             
             let consLeft = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0.0)
             consLeft.isActive = true
             
             self.addConstraints([consTop,consRight,consBottom,consLeft])
             
             self.view.layoutIfNeeded()
             
           

         }
    }
     
    

}

extension CustomNavigation  {
    
    @IBAction func leftButtonPressed(_ btn:UIButton) {
        if (self.headerType == .menu)||(self.headerType == .dashboardMenu ){
            self.menuPressed()
        }else{
            self.navigatForBack()
        }
    }
    
    
    
    private func menuPressed() {
        /*
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        
        
        SideMenuManager.default.leftMenuNavigationController?.settings.presentationStyle = .menuSlideIn
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menu = storyboard.instantiateViewController(withIdentifier: "SideMenuNavigationController") as! SideMenuNavigationController
        menu.leftSide = true
        
        UIApplication.shared.windows.first?.rootViewController?.present(menu, animated: true, completion: nil)
        */
    }
    
    
    func navigatForBack(){
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightNotificationButtonPressed(_ btn:UIButton){
       /*
            appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "NotificationList") as! NotificationList
            appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    @IBAction func rightSettingsButtonPressed(_ btn:UIButton){
        /*
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "UpdateProfileVC") as! UpdateProfileVC
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.pushViewController(vc, animated: true)
 */
    }
}
