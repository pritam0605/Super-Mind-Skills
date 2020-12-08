//
//  LoaderView.swift
//  PMWDriver
//
//  Created by Pritamranjan Dey on 17/09/19.
//  Copyright © 2019 Pritamranjan Dey. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderView: UIView {
    @IBOutlet var vwActivity: NVActivityIndicatorView!
    @IBOutlet var vwContainer : UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LoaderView", owner: self, options: nil)
        vwContainer.frame = frame
        self.addSubview(vwContainer)
        
    }
    
    
    
    func startLoading()  {
       vwActivity.startAnimating()
    }
    func stopLoading()  {
         vwActivity.stopAnimating()
    }
  

}
