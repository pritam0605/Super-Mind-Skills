//
//  Slide.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class Slide: UIView {
  @IBOutlet var imageView:UIImageView!
    func createSlides(imageArray:[String]) -> [Slide] {
        var arrSlide = [Slide]()
        
        
        for (_,object) in imageArray.enumerated(){
            let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide1.imageView.image = UIImage(named: object)
            arrSlide.append(slide1)
        }
        
        return arrSlide
        
        
        
        /*
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "ic_onboarding_1")
    
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "ic_onboarding_2")
       
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "ic_onboarding_3")
        
        let slide4:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide4.imageView.image = UIImage(named: "ic_onboarding_4")
        
        let slide5:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide5.imageView.image = UIImage(named: "ic_onboarding_5")
        
        return [slide1, slide2, slide3, slide4, slide5]
        */
    }

}
