//
//  SlideView.swift
//  SuperMindSkill
//
//  Created by Abhik on 06/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class SlideView: UIView {
    @IBOutlet var containerView:UIView!
    @IBOutlet var imgInitialUser:UIImageView!
    @IBOutlet var txtInitialUser:UITextView!
    func createSlidesView(imageArray:[String],txtArray:[String]) -> [SlideView] {
        var arrSlide = [SlideView]()
        
        
        for (index,object) in imageArray.enumerated(){
            let slide1:SlideView = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! SlideView
            slide1.imgInitialUser.image = UIImage(named: object)
            slide1.txtInitialUser.text = txtArray[index]
            arrSlide.append(slide1)
        }
        
        return arrSlide
        
    }

}
