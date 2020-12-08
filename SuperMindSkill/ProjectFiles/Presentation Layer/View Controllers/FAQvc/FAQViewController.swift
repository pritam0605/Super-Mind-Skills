//
//  FAQViewController.swift
//  SuperMindSkill
//
//  Created by Pritam on 05/03/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class FAQViewController: BaseViewController {
    @IBOutlet weak var textViewFaq:UITextView!
    
    
    
    var pageName:String = ""
     let modelsupport =  supportModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        callSupportApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.vwHeader?.headerType = .back
          self.vwHeader?.lableTitle.text = pageName
    }
    
    func callSupportApi(){
           self.modelsupport.supportApiCall{(status,msg) in
               if(status == 0){
                if (self.pageName == "FAQ") {
                    self.textViewFaq.attributedText = self.modelsupport.supportModelIns?.model_faq?.page_content?.htmlToAttributedString
                }else if  (self.pageName == "ABOUT US") {
                   self.textViewFaq.attributedText = self.modelsupport.supportModelIns?.model_about_us?.page_content?.htmlToAttributedString
                }
                
               
               }
           }
       }
    

}
