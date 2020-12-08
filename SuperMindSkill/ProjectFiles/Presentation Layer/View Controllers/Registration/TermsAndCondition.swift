//
//  TermsAndCondition.swift
//  SuperMindSkill
//
//  Created by Abhik on 11/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import WebKit

class TermsAndCondition: BaseViewController {
    let modelsupport =  supportModel()
    @IBOutlet weak var webView:WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.vwHeader?.lableTitle.text = "Terms And Condition"
        self.vwHeader?.headerType = .back
        
        // Do any additional setup after loading the view.
        ////Call Support Api
        callSupportApi()
    }
    
    func callSupportApi() {
        modelsupport.supportApiCall{(status,msg) in
            if(status == 0){
                //print(self.modelsupport.supportModelIns?.model_terms_condition)
                self.webView.loadHTMLString(self.modelsupport.supportModelIns?.model_terms_condition?.page_content ?? "", baseURL: nil)
            }
        }
    }
    
}
