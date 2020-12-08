//
//  OTPVC.swift
//  EquineOrganiser
//
//  Created by Rupbani on 09/07/19.
//  Copyright © 2019 Rupbani. All rights reserved.
//

import UIKit

class OTPVC: BaseViewController {
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var btnOTPValidation: UIButton!
    
    
    @IBOutlet weak var btnResendOTP: UIButton!
    var sentOtp: String = ""
    var emailAddress: String = ""
    var userId: String = ""
    var regModel = registrationModelClass()
    
    var enteredOtp: String = ""
    var UserDetail: [String:Any] = [String:Any]()
    
    
    var timerCounter = 180
    var timeTaken = 180
    var timer : Timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
         
        otpView.otpFieldsCount = 4
        otpView.otpFieldDefaultBorderColor = .white
        otpView.otpFieldEnteredBorderColor = appBlueColor
        otpView.cursorColor = appGrayColor
        otpView.otpFieldErrorBorderColor = .red
        otpView.otpFieldBorderWidth = 2
        
        otpView.delegate = self
        otpView.shouldAllowIntermediateEditing = false
        
        // Create the UI
        otpView.initializeUI()
        // Do any additional setup after loading the view.
        
        headerLabel.text = "Enter your Verification Code"
        
        /// Schedule Timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        //btnResendOTP.setTitleColor(.gray, for: .normal)
        //btnResendOTP.isEnabled = false
  
    }
    @objc func updateTime() {
        
        
        timerLabel.text = "Time left ( \(timeFormatted(timeTaken)) )"
        if timeTaken != 0 {
            timeTaken -= 1
        } else {
            //btnResendOTP.setTitleColor(.white, for: .normal)
            //btnResendOTP.isEnabled = true
            endTimer()
        }
    }
    
    func endTimer() {
        timer.invalidate()
    }
    override func viewDidDisappear(_ animated: Bool) {
        if (self.timer.isValid) {
            self.timer.invalidate()
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    override func viewDidLayoutSubviews() {
        btnOTPValidation.layer.cornerRadius = btnOTPValidation.frame.size.height / 2
        btnOTPValidation.clipsToBounds = true
    }
    internal func moveToNextScreen() {
        
       
    }
    @IBAction func btnOTPValidationAction(_ sender: UIButton)
    {
        if callOtpValidation(){
           sendOTPAction()
        }
       
   }
    func sendOTPAction(){
       
        regModel.apiForOTPValidation(email: emailAddress, otp: enteredOtp){(status, message) in
            if(status == 0){
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(identifier: "CongratulationVC") as! CongratulationVC
                    self.navigationController?.pushViewController(vc, animated: true)
                   
                }
            }else{
                
                DispatchQueue.main.async {
                    showAlertMessage(title: App_Title, message: message, vc: self)
                }
            }
        }
    }
    @IBAction func btnResendOTPAction(_ sender: UIButton){
        enteredOtp = ""
        otpView.initializeUI()
        //////// CALL FOR RESEND OTP
        callForResendOtpApi()
    }
}
extension OTPVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all Verification Code? \(hasEntered)")
        
        return enteredOtp == "12345"
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        //print("OTPString: \(otpString)")
    }
}
extension OTPVC{
    func callForResendOtpApi()  {
        /*
         if (self.timer.isValid) {
         self.timer.invalidate()
         }
         self.timeTaken = self.timerCounter
         self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
         */
        regModel.apiForResendOtp(email: emailAddress) { (status, message,dictResult)  in
            self.hideLoading()
            /// Schedule Timer
            if (self.timer.isValid) {
                self.timer.invalidate()
            }
            self.timeTaken = self.timerCounter
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            
            if status == 0{
                showAlertMessage(title: App_Title, message: message, vc: self)
                let otp_int = dictResult["otp"]
                self.sentOtp = String(otp_int!)
                
            }else{
                showAlertMessage(title: "Ooops", message: message, vc: self)
            }
        }
    }
    func callOtpValidation()->Bool  {
        guard !(enteredOtp.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) else{
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_OTP_BLANK, vc: self)
            return false
        }
        guard !(timeTaken == 0)
         else{
            showAlertMessage(title: "Ooops", message: "Verification Code expired. Please resend Verification Code", vc: self)
            return false
        }
       return true
    }
    func hideMidChars(_ value: String) -> String {
       return String(value.enumerated().map { index, char in
          return [0].contains(index) ? char : "*"
       })
    }
}

