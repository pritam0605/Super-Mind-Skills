//
//  MessageConstent.swift
//  WorldPeaceArtProgram
//
//  Created by Rupbani on 04/10/19.
//  Copyright © 2019 Rupbani. All rights reserved.
//

import Foundation
import UIKit

let ALERT_MESSAGE_BLANK = " should not blank."
let ALERT_PHONE_NUMBER = "Your mobile number must contain ten or more characters."
let ALERT_MESSAGE_PASSWORD_BLANK = ("Password").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_EMAIL_BLANK = ("E-mail address").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_OTP_BLANK = ("Verification Code").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_FIRST_BLANK = ("Frist Name").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_LAST_BLANK = ("Last Name").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_PHONE_COUNTRY_BLANK = ("Country code").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_PHONE_BLANK  = "Your mobile no should be 10 to 15 digits"

let ALERT_MESSAGE_DOB_BLANK = ("DOB").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_DOB_VALID = "Age need to be greater than 18 years"
let ALERT_MESSAGE_AGE_BLANK = ("Age").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_COUNTRY_BLANK = ("Country").appending(ALERT_MESSAGE_BLANK)

let ALERT_MESSAGE_SCHOOL_NAME_BLANK = ("School Name").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_SCHOOL_TYPE_OPTION_BLANK = ("School type").appending(ALERT_MESSAGE_BLANK)

let ALERT_MESSAGE_PASS_INVALID = "Your password must contain 6 to 10 characters."
let ALERT_MESSAGE_PASS_NOT_MATCH = "Your password is not matching with confirm password."


let ALERT_MESSAGE_SELECT_BOX = "Pleace check the box before continue."


let ALERT_MESSAGE_WHATS_APP = "You don't have What's on your phone "
//whatsapp is not install in your phone
let ALERT_API_MESSAGE_REGISTER = "Congratulations! You have register successfully. Please login again."
let ALERT_MESSAGE_NAME_NOT_BLANK = ("Name field").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_NAME_INVALID = "Please enter a valid name."
let ALERT_MESSAGE_DATE_COMPARE = "Start date should not greater than end date."
let ALERT_MESSAGE_TITLE_BLANK = ("Title field").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_DESCRIPTION_BLANK = ("Description field").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_START_DATE_BLANK = "Please provide a valid start date."
let ALERT_MESSAGE_CHOOSE_OPTION = "Please select an option."
let ALERT_CAM = "Camera"
let ALERT_GALLERY = "Gallery"
let ALERT_MESSAGE_END_DATE_BLANK = "Please provide a valid end date."
let ALERT_MESSAGE_EMAIL_INVALID = "Please provide a valid e-mail address."
let ALERT_MESSAGE_EMAIL_INVALID_2 = "Invalid e-mail address."



let ALERT_API_ERROR = "Sorry, due to some unavoidable circumstances we are unable to process your request. Please try after sometime."
let ALERT_API_DUPLICATE_EMAIL = "Sorry, this email id is already registered with us."
let ALERT_API_EMAIL_NOT_FOUND = "Sorry, your email id/ password is wrong."
let ALERT_API_FORGOT_PASSWORD = "Reset link has been sent to your email address. Please check your email inbox."
let ALERT_API_REGISTRATION_SUCCESS = "Thanks for registering with us. Please login to continue."
let TITLE_FORGOT_PASSWORD = "Forgot Password?"
let ALERT_API_MESSAGE_POINT_ADDED_FAILED = "Failed to add reward points. Please try after sometime."
let ALERT_API_NOTIFICATION_SENT_FAIL = "Sorry, we are unable to send notification."
let ALERT_MESSAGE_NOTIFICATION_TEXT = ("Message").appending(ALERT_MESSAGE_BLANK)


let ALERT_MESSAGE_TOTAL_EXTRA_START_BLANK = ("Total + Extra start reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_TOTAL_EXTRA_FINISH_BLANK = ("Total + Extra finish reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_PAIDKM_START_BLANK = ("Paid KM start reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_PAIDKM_FINISH_BLANK = ("Paid KM finish reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_TOTALKM_START_BLANK = ("Total KM start reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_TOTALKM_FINISH_BLANK = ("Total KM finish reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_HIRINGS_START_BLANK = ("No of Hirings start reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_HIRINGS_FINISH_BLANK = ("No of Hirings finish reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_EXTRA_START_BLANK = ("Extra start reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_EXTRA_FINISH_BLANK = ("Extra finish reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_CARSPEED_START_BLANK = ("Car speed reading").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_CARSPEED_FINISH_BLANK = ("Car speed finish reading").appending(ALERT_MESSAGE_BLANK)

let ALERT_MESSAGE_ARTWORK_NAME_BLANK = ("ArtWork name").appending(ALERT_MESSAGE_BLANK)
let ALERT_MESSAGE_ARTWORK_DESCRIPTION_BLANK = ("ArtWork description").appending(ALERT_MESSAGE_BLANK)

let ALERT_MESSAGE_START_VALUE_BIGGER = "Finish reading cannot was less than start reading"
let ALERT_MESSAGE_IMAGE_UPLOAD = "Please upload image before submission."
let ALERT_MESSAGE_PIN_INVALID = " Post code should have 4 number."
let ALERT_MESSAGE_COMMENT_BLANK = "Message cann't be blank"

let ALERT_MESSAGE_WRONG = "Something went wrong"

func showAlertMessageWithActionButton(title: String, message: String, actionButtonText: String,cancelActionButtonText: String, vc: UIViewController, complitionHandeler: @escaping(_ status: Int)-> (Void)){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //alert.view.backgroundColor = themeColor
    alert.addAction(UIAlertAction(title: cancelActionButtonText , style: .default, handler: { (action) in
        
    }))
    alert.addAction(UIAlertAction(title: actionButtonText,
                                      style: .default,
                                      handler: {(_: UIAlertAction!) in
                                        complitionHandeler(1)
        }))
        vc.present(alert, animated: true, completion: nil)
}


func showAlertMessage(title: String, message: String,  vc: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}


func showAlertMessageWithOkAction(title: String, message: String, vc: UIViewController, complitionHandeler: @escaping(_ status: Int)-> (Void)){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: {(_: UIAlertAction!) in
                                    complitionHandeler(1)
    }))
    vc.present(alert, animated: true, completion: nil)
}
