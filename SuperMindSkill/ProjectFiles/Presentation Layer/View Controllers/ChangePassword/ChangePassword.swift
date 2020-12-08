//
//  ChangePassword.swift
//  SuperMindSkill
//
//  Created by Pritam on 13/03/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePassword: BaseViewController {
    @IBOutlet weak var newTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var conformTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    let savedEmail = UserDefaults.standard.object(forKey: "USEREMAIL")
    var loginModel = loginModelClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwHeader?.lableTitle.text = "CHANGE PASSWORD"
        self.vwHeader?.headerType = .back
 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnContinue.layer.borderWidth = 2.0
        btnContinue.layer.cornerRadius = btnContinue.bounds.size.height / 2
        btnContinue.layer.borderColor = UIColor.clear.cgColor
    }
    
    func validation() -> Bool {
        guard newTextField.text != "" else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PASSWORD_BLANK, vc: self)
            return false
        }
        guard conformTextField.text == newTextField.text  else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PASS_NOT_MATCH, vc: self)
            return false
        }
        
        return true
    }
    @IBAction func buttonDidtapChangePassword(_ sender: UIButton){
        if self.validation(){
            loginModel.ChangetPasswordApiCall(password: newTextField.text!, email: savedEmail as! String){(status,message,dict) in
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

    extension ChangePassword{
        @IBAction func backToPreviousDidTap(_ sender: UIButton){
            backToPrevious()
        }
        
       func backToPrevious(){
            appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
            appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.popViewController(animated: true)
        }
    }

    

   

