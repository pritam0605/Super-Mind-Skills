//
//  PlayListViewController.swift
//  SuperMindSkill
//
//  Created by Pritam on 03/03/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit
import AVFoundation
import SkyFloatingLabelTextField

class PlayListViewController: BaseViewController {
    var model:ModelRecordData?
    var selectedIndex: Int = -99
    var arrUserDataRecord = [ModelRecordData]()
    @IBOutlet weak var textTitle: SkyFloatingLabelTextField!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textGoal: SkyFloatingLabelTextField!
    @IBOutlet weak var playButton: UIButton!
    var songPlayer:AVPlayer?
    var songPlayer2:AVPlayer?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        textGoal.text = model?.Goal
        textTitle.text = model?.Title
        textTitle.textAlignment = .center
        textGoal.textAlignment = .center
        
        labelTitle.isHidden = (model?.Title == "" ) ? true : false
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwHeader?.headerType = .back
        self.playButton.isSelected = false
        self.vwHeader?.lableTitle.text = "Set Volumes"
        print(self.model?.selectedMusicUrl ?? "")
        print(self.model?.recordUrl ?? "")
        
        let url1 = self.getFileFromDocumentDirectory(fileName: self.model?.selectedMusicUrl ?? "")
        
        self.prepareSongAndSessionBackRecoding(playUrl: url1)
        let url2 = self.getFileFromDocumentDirectory(fileName: self.model?.recordUrl ?? "")
        self.prepareSongAndSessionBackGround(playUrl: url2)
        
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: songPlayer?.currentItem, queue: nil) { (_) in
            self.songPlayer?.seek(to: CMTime.zero)
            self.songPlayer?.play()
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: songPlayer2?.currentItem, queue: nil) { (_) in
            self.songPlayer2?.seek(to: CMTime.zero)
            self.songPlayer2?.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if ((self.songPlayer?.rate) != nil){
            self.songPlayer?.pause()
            self.songPlayer = nil
        }
        if ((self.songPlayer2?.rate) != nil){
            self.songPlayer2?.pause()
            self.songPlayer2 = nil
        }
        NotificationCenter.default.removeObserver(self)
       
    }
    
    func prepareSongAndSessionBackGround(playUrl: URL) {
        
        let playerItem:AVPlayerItem = AVPlayerItem(url: playUrl)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, options: [.mixWithOthers, .allowAirPlay, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionError {
            print(sessionError)
        }
        songPlayer = AVPlayer(playerItem: playerItem)
       // songPlayer?.play()
        
        
    }
    
    
    func prepareSongAndSessionBackRecoding(playUrl: URL) {
        let playerItem:AVPlayerItem = AVPlayerItem(url: playUrl)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, options: [.mixWithOthers, .allowAirPlay, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionError {
            print(sessionError)
        }
        songPlayer2 = AVPlayer(playerItem: playerItem)
        //songPlayer2?.play()
    }
    
     

    
    
    @IBAction func buttonTapDelete(_ sender: UIButton) {
        deletAndSave(arr: arrUserDataRecord, index: selectedIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderRecordingSound(_ sender: UISlider) {
       let currentValue = Float(sender.value)
       if  self.songPlayer != nil{
           self.songPlayer?.volume = currentValue
       }
    }
    @IBAction func sliderValueChangeMusic(_ sender: UISlider) {
        let currentValue = Float(sender.value)
               if  self.songPlayer2 != nil{
                   self.songPlayer2?.volume = currentValue
               }
    }
    
    
    @IBAction func buttonClickPlay(_ sender: UIButton) {
        self.playButton.isSelected = !sender.isSelected
        if self.playButton.isSelected {
            //         let url1 = self.getFileFromDocumentDirectory(fileName: self.model?.selectedMusicUrl ?? "")
            //         self.prepareSongAndSessionBackRecoding(playUrl: url1)
            //         let url2 = self.getFileFromDocumentDirectory(fileName: self.model?.recordUrl ?? "")
            //        self.prepareSongAndSessionBackGround(playUrl: url2)
            
            if ((self.songPlayer?.rate) != nil){
                self.songPlayer?.play()
                
            }
            if ((self.songPlayer2?.rate) != nil){
                self.songPlayer2?.play()
            }
        }else{
            if ((self.songPlayer?.rate) != nil){
                self.songPlayer?.pause()
                
            }
            if ((self.songPlayer2?.rate) != nil){
                self.songPlayer2?.pause()
            }
        }
    }
    
}
