//
//  RecordingVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 30/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class RecordingVC: BaseViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var buttonPlayButton: UIButton!
    var savedAllRecording = [ModelRecordData]() // new line
    var soundFileName:String = "recording.m4a"
    var objRecordData3:ModelRecordData?
    @IBOutlet var customTabbar:CustomVerticalTabbarView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    @IBOutlet var btnStartSession:UIButton!
    var isSessionStart = false
    var isBeforePlay = false
    var audioFilename_recording: URL?
    @IBOutlet var timerLabel:UILabel!
    
    var timerCounter = 0
    var timeTaken = 0
    var timer : Timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwHeader?.lableTitle.text = "RECORDING"
        self.vwHeader?.headerType = .back
        tabbarUISetup()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnStartSession.layer.borderWidth = 2.0
        btnStartSession.layer.cornerRadius = btnStartSession.frame.size.height / 2
        btnStartSession.layer.borderColor = UIColor.white.cgColor
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //////stop backgroundMusic
        MusicPlayer.shared.stopBackgroundMusic()
        ///Stop Micro Phone
        RecorderClass.shared.endRecord()
        self.buttonPlayButton.isHidden = true
        self.buttonPlayButton.isSelected = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.buttonPlayButton.isHidden = true
        self.isSessionStart = false
        btnStartSession.setTitle("Start Session", for: .normal)
        timerLabel.text = "00:00"
        btnStartSession.backgroundColor = appBlueColor
        self.fetchRecordDemographicData()
    }
    
    func fetchRecordDemographicData(){
        do {
            if let data = UserDefaults.standard.data(forKey: "USER_AUDIO_MERGED_RECORD_DATA"),
                let arrDataUnsavedResult = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ModelRecordData
            {
                objRecordData3 = arrDataUnsavedResult
            }
           
        }catch{
            
        }
    }
    
    @IBAction func buttonPlay(_ sender: UIButton) {
        self.buttonPlayButton.isSelected = !sender.isSelected
       
        if   self.buttonPlayButton.isSelected{
        if let mergeAudioURLStr = audioFilename_recording {
                DispatchQueue.global(qos: .background).async {
                    MusicPlayer.shared.startBackgroundMusicPlayBySession(musicMurl:mergeAudioURLStr)
                }
            }else{
            MusicPlayer.shared.pauseBackgroundMusic()
        }
        }else{
            MusicPlayer.shared.pauseBackgroundMusic()
        }
        
    }
    
    
    //MARK:- Set Recording Session
    func setUpRecordingSession()  {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
            }
        } catch {
            // failed to record!
        }
    }
    
    //MARK: - Finish Recording
    func finishRecording(success: Bool) {
        if(audioRecorder != nil){
            audioRecorder.stop()
        }
       
        objRecordData3?.recordUrl =  self.soundFileName
        btnStartSession.setTitle("Start Session", for: .normal)
        btnStartSession.backgroundColor = appBlueColor
        self.isSessionStart = false
        self.buttonPlayButton.isHidden = false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    //MARK: delegate function
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func startRecording() {
        let timestamp =  Int64(Date().timeIntervalSince1970 * 1000)
        self.soundFileName = "recording\(timestamp).m4a"
        print(soundFileName)
        audioFilename_recording =  getDocumentsDirectory().appendingPathComponent(soundFileName)
          let settings = [
              AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
              AVSampleRateKey: 12000,
              AVNumberOfChannelsKey: 1,
              AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
          ]
          do {
              audioRecorder = try AVAudioRecorder(url: audioFilename_recording!, settings: settings)
              audioRecorder.delegate = self
              audioRecorder.record()
              btnStartSession.setTitle("Stop Session", for: .normal)
              btnStartSession.backgroundColor = .red
          } catch {
             
          }
      }
    
    
    func tabbarUISetup(){
        ///// Call Custom Tabbar
        customTabbar.setup(activeFor:"Recording")
        customTabbar.myDelegate = self
        makeShadowToChildView(shadowView: customTabbar)
    }
    
    func finalSave()  {

        if let totalSaveArray =    UserDefaults.standard.data(forKey: "FinalSound") {
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: totalSaveArray) as! [ModelRecordData]
            self.savedAllRecording.removeAll()
            self.savedAllRecording = decodedTeams
        }
        self.savedAllRecording.append(self.objRecordData3!)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.savedAllRecording)
        UserDefaults.standard.set(encodedData, forKey: "FinalSound")
        UserDefaults.standard.synchronize()
        let vc = self.storyboard?.instantiateViewController(identifier: "AffirmationViewController") as! AffirmationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension RecordingVC:CustomVerticalTabbarDelegate {
    func GetSelectedIndex(Index: Int) {
        if(isSessionStart){
            showAlertMessage(title: "Ooops", message: "Please stop the session", vc: self)
            return
        }else{
            if(Index == 1){
                let vc = self.storyboard?.instantiateViewController(identifier: "RecordingTitleVC") as! RecordingTitleVC
                self.navigationController?.popPushToVC(ofKind: RecordingTitleVC.self, pushController: vc)
            }
            else if(Index == 2){
                let vc = self.storyboard?.instantiateViewController(identifier: "MusicVC") as! MusicVC
                self.navigationController?.popPushToVC(ofKind: MusicVC.self, pushController: vc)
                
            }else if(Index == 3){
                
            }else if(Index == 4){
                finalSave()
            }
        }
    }
}
extension RecordingVC{
    @IBAction func buttonDidtapNext(_ sender: UIButton){
        if(isSessionStart){
            showAlertMessage(title: "Ooops", message: "Please stop the session", vc: self)
            return
        }else{
            let vc = self.storyboard?.instantiateViewController(identifier: "RecordSaveVC") as! RecordSaveVC
            vc.objRecordData4 = objRecordData3
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
}

///Mark : Music Recording Work
extension RecordingVC{
    ///Mark: PlayPause Music
    @IBAction func buttonDidtapStartSession(_ sender: UIButton){
        if(isSessionStart){
            endTimer()
            finishRecording(success: true)
        }else{
            //// start timer
            startTimer()
            isSessionStart = true
            self.buttonPlayButton.isHidden = true
            MusicPlayer.shared.pauseBackgroundMusic()
            self.buttonPlayButton.isSelected = false
            timeTaken = 0
            startRecording()
        }
    }
}

//Mark: Slider Work
extension RecordingVC{
    @IBAction func slideBackgroundMusic(_ sender: UISlider){
        let currentValue = Float(sender.value)
        MusicPlayer.shared.changeVolumBackgroundMusic(value: currentValue)
        
    }
}

//Mark: Timer Work
extension RecordingVC{
    
    func startTimer(){
        /// Schedule Timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(timeTaken))"
        timeTaken += 1
        
        if(timeTaken == 60){
            ///// end timer
            endTimer()
            self.finishRecording(success: true)
            
        }
    }
    func endTimer() {
        timer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "00:%02d", seconds)
    }
}




