//
//  LoginVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class CustomActivityIndicator: UIView {

    @IBOutlet var view: UIView?
    
    static let sharedInstance = CustomActivityIndicator()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setup()
    }
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() -> Void {
        self.view = Bundle.main.loadNibNamed("CustomActivityIndicator", owner: self, options: nil)?.first as! UIView?
        self.view?.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.addSubview(self.view!)
    }
    
    
    func display(onView vw:UIView!,done:@escaping ()->()){
        self.frame = CGRect(x: vw.frame.origin.x, y: vw.frame.origin.y, width: vw.frame.size.width, height: vw.frame.size.height)
        vw.addSubview(self)
    }
    
    func hide(_:@escaping ()->()){
        self.removeFromSuperview()
    }
}
