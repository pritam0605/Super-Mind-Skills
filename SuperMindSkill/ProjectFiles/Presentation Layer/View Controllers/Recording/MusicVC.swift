//
//  MusicVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 30/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import AVKit
class MusicVC: BaseViewController {
    @IBOutlet var customTabbar:CustomVerticalTabbarView!
    @IBOutlet var tblMusic:UITableView!
    var objRecordData2:ModelRecordData?
    var musicHeader = ["Accordion","Bagpipes","Banjo","Bass guitar"]
   /// for selecetion on merge
    var selectedIndexForMusic = 0
     ///// for playing only
    var selectedIndexForMusicPlay = 0
    @IBOutlet var btnNext:UIButton!
    
    let recordModelClass =  RecordModelClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwHeader?.lableTitle.text = "MUSIC"
        self.vwHeader?.headerType = .back
        // Do any additional setup after loading the view.
        ///// Call Custom Tabbar
        tabbarUISetup()
       

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         callDashBoardApi()
        self.fetchRecordDemographicData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        //////stop backgroundMusic
        MusicPlayer.shared.stopBackgroundMusic()
        ///Stop Micro Phone
        RecorderClass.shared.endRecord()
    }
    
    func fetchRecordDemographicData(){
        do {
            if let data = UserDefaults.standard.data(forKey: "USER_AUDIO_MERGED_RECORD_DATA"),
                let arrDataUnsavedResult = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ModelRecordData
            {
                objRecordData2 = arrDataUnsavedResult
            }
           self.selectedIndexForMusic = UserDefaults.standard.integer(forKey: "selectedIndexForMusic")
            self.tblMusic.reloadData()
        }catch{
            
        }
    }

    func callDashBoardApi() {
        recordModelClass.apiForFetchingMusicList{(status,msg) in
            if(status == 0){
            }
            self.tblMusic.reloadData()
        }
    }
    func tabbarUISetup(){
        customTabbar.setup(activeFor:"Music")
        customTabbar.myDelegate = self
        makeShadowToChildView(shadowView: customTabbar)
    }
    
    func moveToRecording() {
        if(selectedIndexForMusic == 0){
            showAlertMessage(title: "Ooops", message: "Please select a song ", vc: self)
            return
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.objRecordData2!)
        UserDefaults.standard.set(encodedData, forKey: "USER_AUDIO_MERGED_RECORD_DATA")
        UserDefaults.standard.set(selectedIndexForMusic, forKey: "selectedIndexForMusic")
        UserDefaults.standard.synchronize()
        let vc = self.storyboard?.instantiateViewController(identifier: "RecordingVC") as! RecordingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
extension MusicVC:CustomVerticalTabbarDelegate {

    func GetSelectedIndex(Index: Int) {
        //print(Index)
        if(selectedIndexForMusic == 0){
            showAlertMessage(title: "Ooops", message: "Please select a song to play", vc: self)
            return
        }
        
        if (Index == 1){
            let vc = self.storyboard?.instantiateViewController(identifier: "RecordingTitleVC") as! RecordingTitleVC
            self.navigationController?.popPushToVC(ofKind: RecordingTitleVC.self, pushController: vc)
        }
        else if(Index == 2){
            
        }else if(Index == 3){
            guard !(self.objRecordData2?.selectedMusicUrl.isEmpty ?? true) else {
                showAlertMessage(title: "Ooops", message: "Please Select a music", vc: self)
                return
            }
            
            self.moveToRecording()
        }else if(Index == 4){
            guard !(self.objRecordData2?.recordUrl.isEmpty ?? true) else {
                showAlertMessage(title: "Ooops", message: "Please record somethings", vc: self)
                return
            }
            
        }
    }
}
extension MusicVC:UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.recordModelClass.musicList?.music_list?.count ?? 0 ) + 1//musicHeader.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell: CommonCellTableViewCell = self.tblMusic.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell1", for: indexPath as IndexPath)as! CommonCellTableViewCell
            cell.lblHeader.text = "SELECT YOUR CHOICE OF MEDITATIVE MUSIC"//"The best way to not to feel helpless is to get up & do something"
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
             
            return cell
        }else{
            
            let cell: CommonCellTableViewCell = self.tblMusic.dequeueReusableCell(withIdentifier: "CommonCellTableViewCell2") as! CommonCellTableViewCell
            var title = " "
            if let title_temp = (self.recordModelClass.musicList?.music_list?[indexPath.row - 1])?.music_title {
                title = title_temp
            }
            cell.lblHeader.text = title//musicHeader[indexPath.row - 1]
            
            if let title_temp = (self.recordModelClass.musicList?.music_list?[indexPath.row - 1])?.music_description {
                title = title_temp
            }
            cell.lblInfo.attributedText = title.htmlToAttributedString
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            makeShadowToChildView(shadowView: cell.vwContainer)
            
            if(indexPath.row == selectedIndexForMusicPlay){
                cell.imgContent.image = UIImage(named: "MusicPauseActive")
            }else{
                cell.imgContent.image = UIImage(named: "MusicPlayActive")
            }
            
            if(indexPath.row == selectedIndexForMusic){
                let image = UIImage(systemName: "checkmark.circle")
                cell.btnInstance.setImage(image, for: .normal)
            }else{
               
                let image = UIImage(systemName: "circle")
                cell.btnInstance.setImage(image, for: .normal)
            }
            cell.btnInstance.addTarget(self, action: #selector(selectMusicPressed(_:)), for: .touchUpInside)
            cell.btnInstance.tag = indexPath.row
            
         //   cell.btnOverAll.addTarget(self, action: #selector(selectMusicPlayPressed(_:)), for: .touchUpInside)
            cell.btnOverAll.tag = indexPath.row
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            if let MusicUrl = (self.recordModelClass.musicList?.music_list?[indexPath.row - 1])?.music_url {
                if(selectedIndexForMusic == indexPath.row){
                    selectedIndexForMusic = 0
                }else{
                    CustomActivityIndicator.sharedInstance.display(onView: UIApplication.shared.keyWindow, done: {
                        
                    })
                    selectedIndexForMusic = indexPath.row
                    let encodedString = MusicUrl//.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                    
                    downloadFileFromURLAfterSelection(urlStr_para: encodedString,selectedIndex:indexPath.row)
                }
                tblMusic.reloadData()
            }
        }
    }
}
extension MusicVC{
    
    @IBAction func buttonDidtapNext(_ sender: UIButton){
        self.moveToRecording()
    }
}


extension MusicVC{
    @objc func selectMusicPressed(_ sender: UIButton!){
        if let MusicUrl = (self.recordModelClass.musicList?.music_list?[sender.tag - 1])?.music_url {
            if(selectedIndexForMusic == sender.tag){
                DispatchQueue.global(qos: .background).async { // added by pritam on 10th march
                    MusicPlayer.shared.pauseBackgroundMusic()// added by pritam on 10th
                }// added by pritam on 10th
                selectedIndexForMusic = 0
            }else{
                CustomActivityIndicator.sharedInstance.display(onView: UIApplication.shared.keyWindow, done: {
                                      
                                  })
                selectedIndexForMusic = sender.tag
                let encodedString = MusicUrl//.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                
                downloadFileFromURLAfterSelection(urlStr_para: encodedString,selectedIndex:sender.tag)
            }
            tblMusic.reloadData()
        }
        
        //selectedIndexForMusic = sender.tag
        tblMusic.reloadData()
    }
    ///Mark: use for play and pause music only
    @objc func selectMusicPlayPressed(_ sender: UIButton!){
        if let MusicUrl = (self.recordModelClass.musicList?.music_list?[sender.tag - 1])?.music_url {
            if(selectedIndexForMusicPlay == sender.tag){
                DispatchQueue.global(qos: .background).async {
                    MusicPlayer.shared.pauseBackgroundMusic()
                }
                selectedIndexForMusicPlay = 0
            }else{
                CustomActivityIndicator.sharedInstance.display(onView: UIApplication.shared.keyWindow, done: {
                    
                })
                selectedIndexForMusicPlay = sender.tag
                let encodedString = MusicUrl//.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                
                downloadFileFromURL(urlStr_para: encodedString)
            }
            tblMusic.reloadData()
        }
    }
    func downloadFileFromURL(urlStr_para:String){
        if let audioUrl = URL(string: urlStr_para) {
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
               DispatchQueue.main.async {
                    CustomActivityIndicator.sharedInstance.hide {
                        
                    }
                }
                // if the file doesn't exist
                do {
                    ///////// CALL FRO PLAY VIDEO
                    DispatchQueue.global(qos: .background).async {
                        MusicPlayer.shared.startBackgroundMusic(musicMurl:destinationUrl)
                    }
                    
                } catch let error {
                    
                    print(error.localizedDescription)
                }
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    DispatchQueue.main.async {
                        CustomActivityIndicator.sharedInstance.hide {
                            
                        }
                    }
                    do {
                        
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        ///////// CALL FRO PLAY VIDEO
                        DispatchQueue.global(qos: .background).async {
                            MusicPlayer.shared.startBackgroundMusic(musicMurl:destinationUrl)
                        }
                        
                        
                    } catch let error as NSError {
                        DispatchQueue.main.async {
                        }
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }else{
            print("Un able to play")
        }
    }
    func downloadFileFromURLAfterSelection(urlStr_para:String,selectedIndex:Int){
        let fullNameArr = urlStr_para.components(separatedBy: "/")
        let musicName = fullNameArr.last
        if let audioUrl = URL(string: urlStr_para) {
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                DispatchQueue.main.async {
                    CustomActivityIndicator.sharedInstance.hide {
                        
                    }
                }
                /// added on 10th March as client want ///
                do {
                    ///////// CALL FRO PLAY VIDEO
                    DispatchQueue.global(qos: .background).async {
                        MusicPlayer.shared.startBackgroundMusic(musicMurl:destinationUrl)
                    }
                    
                } catch let error {
                    
                    print(error.localizedDescription)
                }
                
                
                //////////
                
                // if the file doesn't exist
                do {
                    ///////// CALL FRO PLAY VIDEO
                    DispatchQueue.global(qos: .background).async {
                        let selectedObj =
                            SelectedModelRecordData.init(music_id: (self.recordModelClass.musicList?.music_list?[selectedIndex - 1])?.music_id ?? 0,
                                                         music_title:(self.recordModelClass.musicList?.music_list?[selectedIndex - 1])?.music_title ?? "",
                                                         music_description:(self.recordModelClass.musicList?.music_list?[selectedIndex - 1])?.music_description ?? "",
                                                         music_url: (self.recordModelClass.musicList?.music_list?[selectedIndex - 1])?.music_url ?? "")
                        
                        self.objRecordData2?.selectedMusicUrl = musicName ?? ""
                        self.objRecordData2?.selectedMusicTitle = selectedObj.music_title ?? ""
                        do{
                            let data = try Data(contentsOf: destinationUrl)
                            do {
                                // writes the image data to disk
                                try data.write(to: destinationUrl)
                                print("file saved")
                            } catch {
                                print("error saving file:", error)
                            }
                        }catch let error {
                            
                            print(error.localizedDescription)
                        }
                        
                    }
                    
                } catch let error {
                    
                    print(error.localizedDescription)
                }
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    DispatchQueue.main.async {
                        CustomActivityIndicator.sharedInstance.hide {
                            
                        }
                    }
                    do {
                      
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        
                         let data = try Data(contentsOf: destinationUrl)
                            do {
                                // writes the image data to disk
                                try data.write(to: destinationUrl)
                                print("file saved")
                            } catch {
                                print("error saving file:", error)
                            }
                        
                        print("File moved to documents folder")
                        ///////// CALL FRO PLAY VIDEO
                        ///
                        ///
                        /// added on 10th March as client want ///
                        DispatchQueue.global(qos: .background).async {
                            MusicPlayer.shared.startBackgroundMusic(musicMurl:destinationUrl)
                        }
                        //////////////////////
                        
                        DispatchQueue.global(qos: .background).async {

                            let selectedObj =
                                SelectedModelRecordData.init(music_id: (self.recordModelClass.musicList?.music_list?[selectedIndex - 1])?.music_id ?? 0,
                                                             music_title:(self.recordModelClass.musicList?.music_list?[selectedIndex - 1])?.music_title ?? "",
                                                             music_description:(self.recordModelClass.musicList?.music_list?[selectedIndex - 1])?.music_description ?? "",
                                                             music_url: (self.recordModelClass.musicList?.music_list?[selectedIndex - 1])?.music_url ?? "")
                            
                    self.objRecordData2?.selectedMusicUrl = musicName ?? ""
                    self.objRecordData2?.selectedMusicTitle = selectedObj.music_title ?? ""

                        }
                        
                        
                    } catch let error as NSError {
                        DispatchQueue.main.async {
                            CustomActivityIndicator.sharedInstance.hide {
                                
                            }
                        }
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }else{
            print("Un able to play")
        }
    }

}
