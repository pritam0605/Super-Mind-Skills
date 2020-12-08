//
//  CommonCellTableViewCell.swift
//  WorldPeaceArtProgram
//
//  Created by Pritamranjan Dey on 04/10/19.
//  Copyright © 2019 Rupbani. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CommonCellTableViewCell: UITableViewCell {
    @IBOutlet weak var cellText:SkyFloatingLabelTextField!
    
    @IBOutlet weak var vwContainer:UIView!
    
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var lblInfo:UILabel!
    
    @IBOutlet weak var imgContent:UIImageView!
   
    @IBOutlet weak var btnInstance:UIButton!
    @IBOutlet weak var buttonPlayPause: UIButton!
    
    @IBOutlet weak var cellTextCountryCode:SkyFloatingLabelTextField!
    @IBOutlet weak var cellTextPhone:SkyFloatingLabelTextField!
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var pageController:UIPageControl!
    @IBOutlet weak var btnOverAll:UIButton!
    @IBOutlet weak var lblSeparator:UILabel!
    @IBOutlet weak var gapConstrain:NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupSlideScrollView(slides : [Slide],parentSize:CGSize) {
       scrollView.frame = CGRect(x: 0, y: 0, width: parentSize.width, height: parentSize.height)
        //CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
       scrollView.contentSize = CGSize(width: parentSize.width * CGFloat(slides.count), height: scrollView.frame.size.height)//CGSize(width: self.scrollView.frame.size.width * 5, height: self.scrollView.frame.size.height)//CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
       scrollView.isPagingEnabled = true
       
       for i in 0 ..< slides.count {
           slides[i].frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: scrollView.frame.size.height)//scrollView.frame//CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: self.view.frame.height)
           scrollView.addSubview(slides[i])
       }
   }
    
}
