//
//  ForgetPassword.swift
//  SuperMindSkill
//
//  Created by Abhik on 05/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class ForgetPassword: BaseViewController {
    @IBOutlet weak var emailTextField: DesignabelTextField!
    @IBOutlet weak var btnContinue: UIButton!
    var loginModel = loginModelClass()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            btnContinue.layer.borderWidth = 2.0
            btnContinue.layer.cornerRadius = btnContinue.frame.size.height / 2
            btnContinue.layer.borderColor = UIColor.clear.cgColor
            
            emailTextField.layer.borderWidth = 2.0
            emailTextField.layer.cornerRadius = emailTextField.frame.size.height / 2
            emailTextField.layer.borderColor = UIColor.white.cgColor
          
        }
        func validation() -> Bool {
            guard emailTextField.text != "" else {
               showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_EMAIL_BLANK, vc: self)
               return false
            }
            guard emailTextField.text?.count != 0 else {
               showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PASS_INVALID, vc: self)
               return false
            }

           return true
        }
     @IBAction func buttonDidtapForgetPassword(_ sender: UIButton){
            if self.validation(){
                loginModel.forgetPasswordApiCall(email: emailTextField.text!){(status,message,dict) in
                    if (status == 0){
                        DispatchQueue.main.async {
                            showAlertMessageWithOkAction(title: "", message: message, vc: self, complitionHandeler: { (status) -> (Void) in
                                if status == 1 {
                                    self.backToPrevious()
                                }
                            })
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            showAlertMessage(title: App_Title, message: message, vc: self)
                        }
                    }
                    
                }
                
            }
        }
    }
extension ForgetPassword{
    @IBAction func backToPreviousDidTap(_ sender: UIButton){
        backToPrevious()
    }
   func backToPrevious(){
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.popViewController(animated: true)
    }
}


