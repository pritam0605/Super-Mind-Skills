//
//  ProfileVC.swift
//  HMS
//
//  Created by Dipika on 09/01/20.
//  Copyright © 2020 MET Technologies. All rights reserved.
//

import UIKit
import Kingfisher
import MRCountryPicker
import SkyFloatingLabelTextField

class ProfileVC: BaseViewController {
    var tempcountryCode = "+91"
    @IBOutlet weak var tableProfile: UITableView!
    @IBOutlet weak var btnEdit: UIButton!
    var arrayFieldValue = [String]()
    
    var strcountryCode: String = "+91"
    var selectedCountryNameCode = "IN"
    var modelProfile = modelProfileClass()
    var isbtnEdit:Bool = false
    var ischangeData:Bool = false
    
    var imagepicData : Data?
    fileprivate var imageBase64:String = ""
    var imagePicker = UIImagePickerController()
    //var tagButtonStatePicker:Int = 0
    var profileImage:UIImage?
    var arrayFileInfo : [MultiPartDataFormatStructure] = [MultiPartDataFormatStructure]()

        
    
    @IBOutlet var customTabbar:CustomTabbarView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.vwHeader?.lableTitle.text = "Profile"
        self.vwHeader?.headerType = .back
        self.vwHeader?.tintColor = .white
        self.vwHeader?.rightButton2.isHidden = false
        
        self.vwHeader?.rightButton2.tintColor = .white
        self.vwHeader?.backgroundColor = themeColor
        self.btnEdit.layer.cornerRadius =  self.btnEdit.frame.size.height/2
        tableProfile.delegate = self
        tableProfile.dataSource = self
        tableProfile.reloadData()
        arrayFieldValue = ["","","","","","","","",""]
        self.callgetProfile()
     
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ///// Call Custom Tabbar
        tabbarUISetup()
    }
    func tabbarUISetup(){
        ///// Call Custom Tabbar
        customTabbar.setup(activeFor:"MyAccount")
        customTabbar.myDelegate = self
        makeShadowToChildView(shadowView: customTabbar)
    }
   
    override func viewDidLayoutSubviews(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = self.tableProfile.cellForRow(at: indexPath) as? ProfileImageCell
        if (cell != nil){
            cell?.imageProfile.layer.cornerRadius = (((cell?.imageProfile.frame.height)!) / 2 )
            cell?.imageProfile.clipsToBounds = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func textFieldValueChanged(_ textField:UITextField) {
        arrayFieldValue[textField.tag] = textField.text!
        print (arrayFieldValue)
        
    }
   
    @IBAction func btnEdit(_ sender: Any) {
        if (isbtnEdit) {
            //Second Tap
            self.callUpdateprofileApiCall()
            
        } else {
            //First Tap
            isbtnEdit = true
            btnEdit.setTitle("Save", for: .normal)
         
            self.ischangeData = false
            tableProfile.reloadData()
        }
        
    }

    @IBAction func btnDone(_ sender: Any) {
        strcountryCode = self.tempcountryCode
        let indexPath = IndexPath(row: 3, section: 0)
        let cell = tableProfile.cellForRow(at: indexPath) as! MobileCell
        cell.lblCountryCode.text = strcountryCode
      
    }
  
}
//MARK: - MRCountry Picker Delegate
extension ProfileVC: MRCountryPickerDelegate {
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.tempcountryCode = "\(phoneCode)"
        print(self.tempcountryCode)
        //buttonCountryCode.setTitle(phoneCode, for: .normal)
       // countryPicker.isHidden = true
       
    }
}

//MARK: - API CALL
extension ProfileVC {
    func callUpdateprofileApiCall()  {
        
         guard let userid =  UserDefaults.standard.value(forKey: "USERID") else{
                  return
              }
        modelProfile.apiForUpdateProfile(userid: userid as! String,
                                         firstname: self.arrayFieldValue[0],
                                         lastname: self.arrayFieldValue[1],
                                         country_code:strcountryCode,
                                         mobile: self.arrayFieldValue[3],
                                         address: self.arrayFieldValue[4],
                                          postcode: self.arrayFieldValue[5],
                                         city: self.arrayFieldValue[6],
                                         nationality: self.arrayFieldValue[7],
                                         company: self.arrayFieldValue[8]
                                         ){(status,msg,dict) in
            if (status == 0){
                showAlertMessageWithOkAction(title: App_Title, message: msg, vc: self, complitionHandeler: { (status) -> (Void) in
                    if status == 1 {
                        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
                        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.popViewController(animated: true)
                    }
                })
                //showAlertMessage(title: App_Title, message: msg, vc: self)
            }
            else {
                showAlertMessage(title: App_Title, message: msg, vc: self)
            }
        }
        
    }
    func countryNamesByCode() -> [MyCountry] {
          var countries = [MyCountry]()
          let frameworkBundle = Bundle(for: type(of: self))
          guard let jsonPath = frameworkBundle.path(forResource: "MyCountryList", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
              return countries
          }
          
          do {
              if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                  
                  for jsonObject in jsonObjects {
                      
                      guard let countryObj = jsonObject as? NSDictionary else {
                          return countries
                      }
                      
                      guard let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let name = countryObj["name"] as? String else {
                          return countries
                      }
                      
                      let country = MyCountry(code: code, name: name, phoneCode: phoneCode)
                      countries.append(country)
                  }
                  
              }
          } catch {
              return countries
          }
          return countries
      }
      
    func callgetProfile() {
        let countries = countryNamesByCode()
        if let userid = UserDefaults.standard.value(forKey: "USERID"){
            let userId = "\(userid)"
            modelProfile.apiForGetProfile(userid:userId){(status,msg,dict) in
                if (status == 0){
                    self.arrayFieldValue[0] = objUserProfile.first_name ?? ""
                    self.arrayFieldValue[1] = objUserProfile.last_name ?? ""
                    self.arrayFieldValue[2] = objUserProfile.user_email ?? ""
                    self.arrayFieldValue[3] = objUserProfile.mobile ?? ""
                    self.arrayFieldValue[4] = objUserProfile.address ?? ""
                    self.arrayFieldValue[5] = objUserProfile.postcode ?? ""
                    self.arrayFieldValue[6] = objUserProfile.city ?? ""
                    self.arrayFieldValue[7] = objUserProfile.nationality ?? ""
                    self.arrayFieldValue[8] = objUserProfile.company ?? ""
                    self.strcountryCode = objUserProfile.country_code ?? ""
                    
                    let results = countries.filter({ $0.phoneCode == objUserProfile.country_code ?? "" })
                    if(results.count != 0){
                        self.selectedCountryNameCode = results[0].code ?? ""
                    }
                    if let catPictureURL = URL(string: objUserProfile.profile_pic_url ?? ""){
                        print("url== Souvic",catPictureURL)
                       let index = IndexPath(row: 0, section: 0)
                       let cell = self.tableProfile.cellForRow(at: index) as! ProfileImageCell
                        cell.imageProfile.load(url: catPictureURL)  
                    }
                    self.tableProfile.reloadData()
                }
                else {
                    showAlertMessage(title: App_Title, message: msg, vc: self)
                }
            }
            
        }else{}
    }
    func imageupdateApiCall(){
        guard let userid =  UserDefaults.standard.value(forKey: "USERID") else{
            return
        }
        if ((self.imagepicData) != nil){
            arrayFileInfo.removeAll()
            let imageFileInfo = MultiPartDataFormatStructure.init(key: "profile_pic", mimeType: .image_jpeg, data: self.imagepicData, name: "profile.jpg")
            arrayFileInfo.append(imageFileInfo)
        }
        modelProfile.apiForUpdateProfileimage(userid:userid as! String, imageFileInfo: arrayFileInfo) { (status,msg) in
            if (status == 0){
                self.callgetProfile()
                showAlertMessage(title: App_Title, message: msg, vc: self)
            }
            else {
                showAlertMessage(title: App_Title, message: msg, vc: self)
            }
        }
        
    }

    func validation() -> Bool {
        guard !arrayFieldValue[0].isEmpty else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_FIRST_BLANK, vc: self)
            return false
        }
        guard !arrayFieldValue[1].isEmpty else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_LAST_BLANK, vc: self)
            return false
        }
        
        guard !arrayFieldValue[2].isEmpty else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_EMAIL_INVALID, vc: self)
            return false
        }
        guard arrayFieldValue[2].isValideEmail else {
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_EMAIL_INVALID, vc: self)
            return false
        }
        guard !strcountryCode.isEmpty else{
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_COUNTRY_BLANK, vc: self)
            return false
        }
        guard !arrayFieldValue[3].isEmpty else{
            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_BLANK, vc: self)
            return false
        }
        //        guard !(arrayFieldValue[3].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)else{
        //
        //            showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_BLANK, vc: self)
        //            return false
        //        }
        
        
        guard !arrayFieldValue[4].isEmpty else {
            showAlertMessage(title: "Ooops", message: "Address field can not be blank", vc: self)
            return false
        }
        guard !arrayFieldValue[5].isEmpty else {
            showAlertMessage(title: "Ooops", message: "State field can not be blank", vc: self)
            return false
        }
        guard !arrayFieldValue[5].isEmpty else {
            showAlertMessage(title: "Ooops", message: "Post code field can not be blank", vc: self)
            return false
        }
        guard !arrayFieldValue[6].isEmpty else {
            showAlertMessage(title: "Ooops", message: "City field can not be blank", vc: self)
            return false
        }
        guard !arrayFieldValue[7].isEmpty else {
            showAlertMessage(title: "Ooops", message: "Nationality field can not be blank", vc: self)
            return false
        }
        guard !arrayFieldValue[8].isEmpty else {
            showAlertMessage(title: "Ooops", message: "Company field can not be blank", vc: self)
            return false
        }
        //        if(!isAcceptTermsAndCondition){
        //            showAlertMessage(title: "Ooops", message: "Please accept terms and condition", vc: self)
        //            return false
        //        }
        if strcountryCode.contains("+") {
            guard  MyBasics.isValidPhoneNumberByCountry(numberStr: "\(strcountryCode )\(arrayFieldValue[3])") else {
                showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_COUNTRY_BLANK, vc: self)
                return false
            }
        }else{
            guard  MyBasics.isValidPhoneNumberByCountry(numberStr: "+\(strcountryCode )\(arrayFieldValue[3])") else {
                showAlertMessage(title: "Ooops", message: ALERT_MESSAGE_PHONE_COUNTRY_BLANK, vc: self)
                return false
            }
        }
        return true
    }
}

extension ProfileVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 280
        }
        else {
            return UIDevice.current.userInterfaceIdiom == .phone ? 65 : 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            if (isbtnEdit == false){
                cell.btnUploadPic.isUserInteractionEnabled = false
                cell.imageUpload.isHidden = true
                
            }
            else {
                cell.btnUploadPic.isUserInteractionEnabled = true
                cell.imageUpload.isHidden = false
            }
         
            
            cell.btnUploadPic.addTarget(self, action: #selector(btnUploadPicPressed(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        else if (indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MobileCell", for: indexPath) as! MobileCell
            cell.selectionStyle = .none
            
            cell.lblCountryCode.text = "\(selectedCountryNameCode)\(" ") \(strcountryCode)"  //strcountryCode
            cell.btnSelectCountry.tag = indexPath.row
            cell.btnSelectCountry.addTarget(self, action: #selector(btnSelectCountryPicker(_:)), for: .touchUpInside)
            
            cell.txtMobileNumber?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.txtMobileNumber.tag = 3
            if (isbtnEdit == false){
                cell.txtMobileNumber.isUserInteractionEnabled = false
                cell.btnSelectCountry.isUserInteractionEnabled = false
            }
            else {
                cell.txtMobileNumber.isUserInteractionEnabled = true
                cell.btnSelectCountry.isUserInteractionEnabled = true
            }
            
            cell.txtMobileNumber.text = arrayFieldValue[3]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textinputCell", for: indexPath) as! textinputCell
            cell.txtFieldNameFirst?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.txtFielsNameSecond?.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.selectionStyle = .none
            
            if (isbtnEdit == false){
                cell.txtFieldNameFirst.isUserInteractionEnabled = false
                cell.txtFielsNameSecond.isUserInteractionEnabled = false
            }
            else {
                cell.txtFieldNameFirst.isUserInteractionEnabled = true
                cell.txtFielsNameSecond.isUserInteractionEnabled = true
            }
            if (indexPath.row == 1){
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = false
                cell.txtFieldNameFirst.placeholder = "First Name"
                cell.txtFielsNameSecond.placeholder = "Last Name"
                cell.txtFieldNameFirst.tag = 0
                cell.txtFielsNameSecond.tag = 1
                cell.txtFieldNameFirst.text = arrayFieldValue[0]
                cell.txtFielsNameSecond.text = arrayFieldValue[1]
                
            }
            else if(indexPath.row == 2){
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = true
                cell.txtFieldNameFirst.placeholder = "Email ID"
                cell.txtFieldNameFirst.tag = 2
                cell.txtFieldNameFirst.keyboardType = .emailAddress
                cell.txtFieldNameFirst.text = arrayFieldValue[2]
                cell.txtFieldNameFirst.isUserInteractionEnabled = false //Pritam
            }
            else if(indexPath.row == 4){
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = true
                cell.txtFieldNameFirst.placeholder = "Address"
                cell.txtFieldNameFirst.tag = 4
                cell.txtFieldNameFirst.text = arrayFieldValue[4]
            }
           else if(indexPath.row == 5) {
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = false
                cell.txtFieldNameFirst.placeholder = "Pin"
                cell.txtFielsNameSecond.placeholder = "City"
                cell.txtFieldNameFirst.tag = 5
                cell.txtFielsNameSecond.tag = 6
                cell.txtFieldNameFirst.text = arrayFieldValue[5]
                cell.txtFielsNameSecond.text = arrayFieldValue[6]
            }
            else {
                cell.viewFirst.isHidden = false
                cell.viewLast.isHidden = false
                cell.txtFieldNameFirst.placeholder = "Nationality"
                cell.txtFielsNameSecond.placeholder = "Company"
                cell.txtFieldNameFirst.tag = 7
                cell.txtFielsNameSecond.tag = 8
                cell.txtFieldNameFirst.text = arrayFieldValue[7]
                cell.txtFielsNameSecond.text = arrayFieldValue[8]
            }
            return cell
        }
    }
    
    
}

//MARK:UPDATE PROFILE IMAGE

extension ProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
     @objc func btnUploadPicPressed(_ sender: UIButton!){
            self.view.endEditing(true)
            let alert = UIAlertController(title: "Choose profile image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))
             alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
           
            
        if UIDevice.current.userInterfaceIdiom == .pad {
            print("iPad")
            let indexPath = IndexPath(row: 0, section: 0)
            
            let cell = self.tableProfile.cellForRow(at: indexPath) as? ProfileImageCell
            if (cell != nil){
                alert.popoverPresentationController?.sourceView = cell?.btnUploadPic
            }
            // works for both iPhone & iPad

            present(alert, animated: true) {
                print("option menu presented")
            }
        }else{
            
            self.present(alert, animated: true, completion: nil)
        }
        
        }
        
        func openCamera()
        {
            if(UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        func openGallary()
        {
    
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
            {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            picker.dismiss(animated: true)
            if let pickedimage = info[.editedImage] as? UIImage
            {
                
                //let indexPath = IndexPath(row: 0, section: 0)
                print("Picked image is:",pickedimage)
                //let cell = self.tableProfile.cellForRow(at: indexPath) as! ProfileImageCell
                //cell.imageProfile.image = pickedimage
                self.profileImage = pickedimage
                let resizeImage = self.resizeImage(image: pickedimage, newWidth: 100)!
                let imageData = resizeImage.jpegData(compressionQuality: 0.75)
                //let imageData = UIImage.jpegData(resizeImage)//UIImage.pngData(resizeImage)
                self.imagepicData =  imageData
               // imageBase64 = imageData?.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed) ?? ""
               // UserDefaults.standard.set(imageBase64, forKey: "IMAGE_KEY")
                self.imageupdateApiCall()
                
                UserDefaults.standard.synchronize()
                
                
            }
            else
            {
                print("Something went wrong")
            }
            
            
            self.dismiss(animated: true, completion: nil)
            self.view.setNeedsLayout()
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
        {
            self.dismiss(animated: true, completion: { () -> Void in
                
                
            })
        }
        
        func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
            
            let scale = newWidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
}

extension URL {

    var isValid: Bool {
        get {
            return UIApplication.shared.canOpenURL(self)
        }
    }

}

extension ProfileVC:CustomTabbarDelegate{
    func GetSelectedIndex(Index: Int) {
        print(Index)
        if(Index == 1){
            let vc = self.storyboard?.instantiateViewController(identifier: "DashBoardVC") as! DashBoardVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(Index == 2){
            fetchRecordedData()
        }else if(Index == 3){
            
        }else if(Index == 4){
            let vc = self.storyboard?.instantiateViewController(identifier: "SupportVC") as! SupportVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(Index == 5){
            let vc = self.storyboard?.instantiateViewController(identifier: "AffirmationViewController") as! AffirmationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ProfileVC:CustomCountryPickerDelegate{
    func GetSelectedCountryNameAndCode(CountryName: String, CountryPhoneCode: String,CountryNameCode: String) {
        self.tempcountryCode = CountryPhoneCode
        selectedCountryNameCode = CountryNameCode
        strcountryCode = self.tempcountryCode
        let indexPath = IndexPath(row: 3, section: 0)
        let cell = tableProfile.cellForRow(at: indexPath) as! MobileCell
        cell.lblCountryCode.text = strcountryCode
        self.tableProfile.reloadData()
    }
    
    @objc func btnSelectCountryPicker(_ sender: UIButton){
        MyBasics.showCountryPickerDropDown(ParentViewC: self)
      }
}


extension ProfileVC{
    @IBAction func navigatForBack(_ sender: UIButton){
        
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.view.endEditing(true)
        appDel.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows.first?.rootViewController)?.navigationController?.popViewController(animated: true)
    }
}
  

