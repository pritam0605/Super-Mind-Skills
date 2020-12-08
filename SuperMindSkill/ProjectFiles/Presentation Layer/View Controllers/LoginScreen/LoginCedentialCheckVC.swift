//
//  LoginCedentialCheckVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

class LoginCedentialCheckVC: BaseViewController {
    @IBOutlet weak var emailTextField: DesignabelTextField!
    @IBOutlet weak var passWordTextField: DesignabelTextField!
    @IBOutlet weak var btnLogin: UIButton!
    var strEmial = ""
    var strPassword = ""
    
    var loginModel = loginModelClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        if Platform.isSimulator{
            emailTextField.text = "Abhik.das@met-technologies.com"
            passWordTextField.text = "P@p123456"
          
        }
        
        
        emailTextField.addTarget(self, action: #selector(self.textFieldValueChange(_:)), for: .editingChanged)
        passWordTextField.addTarget(self, action: #selector(self.textFieldValueChange(_:)), for: .editingChanged)
        //cell.cellText.addTarget(self, action: #selector(self.textFieldValueChange(_:)), for: .editingChanged)

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnLogin.layer.borderWidth = 2.0
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height / 2
        btnLogin.layer.borderColor = UIColor.clear.cgColor
        
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.cornerRadius = emailTextField.frame.size.height / 2
        emailTextField.layer.borderColor = UIColor.white.cgColor
        
        passWordTextField.layer.borderWidth = 2.0
        passWordTextField.layer.cornerRadius = passWordTextField.frame.size.height / 2
        passWordTextField.layer.borderColor = UIColor.white.cgColor
        
    }
    func validation() -> Bool {
        guard strEmial != "" else {
           showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_EMAIL_BLANK, vc: self)
           return false
        }
        guard strPassword != "" else {
           showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PASS_INVALID, vc: self)
           return false
        }

       return true
    }
    func aloginapiCall(){
        if self.validation(){
            loginModel.loginApiCall(email: strEmial, passsword: strPassword){(status,message,dict) in
                if (status == 0){
                    //                    let vc = self.storyboard?.instantiateViewController(identifier: "MemeberShipVC") as! MemeberShipVC
                    //                    self.navigationController?.pushViewController(vc, animated: true)
                    if let userID:String = UserDefaults.standard.value(forKey: "USERID") as? String {
                        let appdel = UIApplication.shared.delegate as! AppDelegate
                        let rootViewController = appdel.window?.rootViewController as! UINavigationController
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let model = ModelInAppPurchase()
                        model.detailsOfInAppPurchase(userID: userID) { (status, message) in
                            DispatchQueue.main.async {
                                let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
                                
                                if status == enPurchaseType.logeIn.rawValue {
                                    
                                    appDel.userCurrentSubsCription = .NoMembership
                                    
                                }else if  (status == enPurchaseType.trial.rawValue) || (status == enPurchaseType.membership.rawValue) {
                                    
                                    appDel.userCurrentSubsCription = .OnMmbership
                                } else if (status == enPurchaseType.trialExpire.rawValue) || (status == enPurchaseType.membershipExpire.rawValue){
                                    
                                    appDel.userCurrentSubsCription = .Expire
                                }
                                rootViewController.pushViewController(profileViewController, animated: true)
                            }
                        }
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


extension LoginCedentialCheckVC{
    
    @IBAction func buttonDidtapForgetPassword(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(identifier: "ForgetPassword") as! ForgetPassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonDidtapSignUp(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonDidtapDashBoard(_ sender: UIButton){
        self.aloginapiCall()
        //let vc = self.storyboard?.instantiateViewController(identifier: "MemeberShipVC") as! MemeberShipVC
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backToPrevious(_ sender: UIButton){
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.popViewController(animated: true)
    }
}

extension LoginCedentialCheckVC {
    @objc func textFieldValueChange(_ txt: UITextField)  {
        // superviewOfClassType comes from IQ keyboard managr
        
        self.strEmial = emailTextField.text!
        self.strPassword = passWordTextField.text!
        
    }
}

