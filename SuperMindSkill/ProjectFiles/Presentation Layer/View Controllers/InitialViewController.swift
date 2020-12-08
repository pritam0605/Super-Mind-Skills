//
//  InitialViewController.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    @IBOutlet var btnCancel:UIButton!
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var pageController:UIPageControl!
  
    var slideView:[SlideView] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageTempArr = ["initialUser_prrr"]

        let txtTempArr = [" Super Mind Skill \n\n Life Changing  \n\n Record Your Affirmation In Your Own Voice  \n\n  Choose Music  \n\n Train Your Subconscious \n\n To Be \n Happy Healthy Wise & Wealthy"]
        
        
        slideView = createSlidesViewTemp(imageArray:imageTempArr,txtArray:txtTempArr)
        setupSlideScrollView(slides:slideView)
        //setupSlideScrollView(slides: slides,parentSize:CGSize(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height))
        scrollView.delegate = self
        pageController.numberOfPages = imageTempArr.count
        pageController.currentPage = 0
        
        self.scrollView.bringSubviewToFront(pageController)
        self.scrollView.bringSubviewToFront(btnCancel)
      
  
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
}
extension InitialViewController{
    func setupSlideScrollView(slides : [SlideView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.75)
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(slides.count), height: view.frame.height * 0.75)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: view.frame.height * 0.75)
            //vwContainer.addSubview(slides[i])
            self.scrollView.addSubview(slides[i])
           
        }
       
    }
    func createSlidesViewTemp(imageArray:[String],txtArray:[String]) -> [SlideView] {
        var arrSlide = [SlideView]()
        for (index,object) in imageArray.enumerated(){
            let slideView1:SlideView = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! SlideView
            
            slideView1.imgInitialUser.image = UIImage(named: object)
            slideView1.txtInitialUser.text = txtArray[index]
            arrSlide.append(slideView1)
        }
        
        return arrSlide
        
    }
}
extension InitialViewController:UIScrollViewDelegate{
    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageController.currentPage = Int(pageIndex)
        /*
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageController.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        */
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        /*
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }*/
    }
}
extension InitialViewController{
    @IBAction func buttonDidtapLogin(_ sender: UIButton){
         let vc = self.storyboard?.instantiateViewController(identifier: "LoginVC") as! LoginVC
               self.navigationController?.pushViewController(vc, animated: true)
           
       }
}
