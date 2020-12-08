//
//  CustomVerticalTabbarView.swift
//  SuperMindSkill
//
//  Created by Abhik on 30/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
@objc protocol CustomVerticalTabbarDelegate {
    func GetSelectedIndex(Index:Int)
}
class CustomVerticalTabbarView: UIView {
    var myDelegate:CustomVerticalTabbarDelegate?
    
    @IBOutlet var view: UIView?
    
    @IBOutlet var viewTitle: UIView?
    @IBOutlet var viewMusic: UIView?
    @IBOutlet var viewRecording: UIView?
    @IBOutlet var viewSave: UIView?
    
    @IBOutlet var imgTitle: UIImageView?
    @IBOutlet var imgMusic: UIImageView?
    @IBOutlet var imgRecording: UIImageView?
    @IBOutlet var imgSave: UIImageView?
    
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblMusic: UILabel?
    @IBOutlet var lblRecording: UILabel?
    @IBOutlet var lblSave: UILabel?
    
      func setup(activeFor:String) -> Void {
            self.view = Bundle.main.loadNibNamed("CustomVerticalTabbarView", owner: self, options: nil)?.first as! UIView?
            self.view?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            self.addSubview(self.view!)
            if(activeFor == "Title"){
                viewTitle?.backgroundColor = .white
                imgTitle?.image = UIImage(named: "titleActive")
                lblTitle?.textColor = appGrayColor
            }else if(activeFor == "Music"){
                 viewMusic?.backgroundColor = .white
                               imgMusic?.image = UIImage(named: "musicActive")
                               lblMusic?.textColor = appGrayColor
            }
            else if(activeFor == "Recording"){
                 viewRecording?.backgroundColor = .white
                               imgRecording?.image = UIImage(named: "microphoneActive")
                               lblRecording?.textColor = appGrayColor
            }
           else if(activeFor == "Save"){
                viewSave?.backgroundColor = .white
                               imgSave?.image = UIImage(named: "saveActive")
                               lblSave?.textColor = appGrayColor
            }
        }
        @IBAction func selectionTabbar(_ sender: UIButton){
            myDelegate?.GetSelectedIndex(Index: sender.tag)
        }
    }
