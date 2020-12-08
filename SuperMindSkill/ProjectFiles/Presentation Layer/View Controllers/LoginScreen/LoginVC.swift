//
//  LoginVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    @IBOutlet var btnLogin:UIButton!
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnLogin.layer.borderWidth = 2.0
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height / 2
        btnLogin.layer.borderColor = UIColor.white.cgColor
        
        
        
    }
      
}
extension LoginVC{
    @IBAction func buttonDidtapLogin(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(identifier: "LoginCedentialCheckVC") as! LoginCedentialCheckVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func buttonDidtapSignUp(_ sender: UIButton){
     
         let vc = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
         self.navigationController?.pushViewController(vc, animated: true)
         
    }
}
