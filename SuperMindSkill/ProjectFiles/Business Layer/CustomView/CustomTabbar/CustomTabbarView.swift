//
//  CustomTabbarView.swift
//  SuperMindSkill
//
//  Created by Abhik on 30/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
@objc protocol CustomTabbarDelegate {
    func GetSelectedIndex(Index:Int)
}
class CustomTabbarView: UIView {
    
    var myDelegate:CustomTabbarDelegate?
    
    @IBOutlet var view: UIView?
    
    @IBOutlet var viewHome: UIView?
    @IBOutlet var viewRecording: UIView?
    @IBOutlet var viewMyAccount: UIView?
    @IBOutlet var viewSupport: UIView?
    @IBOutlet var viewAffirmation: UIView?
    
    @IBOutlet var imgHome: UIImageView?
    @IBOutlet var imgRecording: UIImageView?
    @IBOutlet var imgMyAccount: UIImageView?
    @IBOutlet var imgSupport: UIImageView?
    @IBOutlet var imgAffirmation: UIImageView?
    
    @IBOutlet var lblHome: UILabel?
    @IBOutlet var lblRecording: UILabel?
    @IBOutlet var lblMyAccount: UILabel?
    @IBOutlet var lblSupport: UILabel?
    @IBOutlet var lblAffirmation: UILabel?
    
    func setup(activeFor:String) -> Void {
        self.view = Bundle.main.loadNibNamed("CustomTabbarView", owner: self, options: nil)?.first as! UIView?
        self.view?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.addSubview(self.view!)
     
        if(activeFor == "Home"){
            viewHome?.backgroundColor = themeColor
            imgHome?.image = UIImage(named: "homeActive")
            lblHome?.textColor = .white
        }else if(activeFor == "Recording"){
            viewRecording?.backgroundColor = themeColor
            imgRecording?.image = UIImage(named: "recorderActive")
            lblRecording?.textColor = .white
        }
        else if(activeFor == "MyAccount"){
            viewMyAccount?.backgroundColor = themeColor
            imgMyAccount?.image = UIImage(named: "MyAccountActive")
            lblMyAccount?.textColor = .white
        }
        else if(activeFor == "Support"){
            viewSupport?.backgroundColor = themeColor
            imgSupport?.image = UIImage(named: "SupportActiveWhite")
            lblSupport?.textColor = .white
        }
        else if(activeFor == "Affirmation"){
            viewAffirmation?.backgroundColor = themeColor
            imgAffirmation?.image = UIImage(named: "Affirmation_w")
            lblAffirmation?.textColor = .white
            
        }
    }
    @IBAction func selectionTabbar(_ sender: UIButton){
        myDelegate?.GetSelectedIndex(Index: sender.tag)
    }
}
