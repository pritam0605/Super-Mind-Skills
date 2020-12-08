//
//  MusicPlayer.swift
//  SuperMindSkill
//
//  Created by Abhik on 03/02/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import Foundation
import AVFoundation

import UIKit
import AVKit
import CoreAudioKit

/**
 Mark: CLASS For BACK Ground Music and Merge
 */

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    
    /**
    Mark: Start palying
    */
    func startBackgroundMusicPlayBySession(musicMurl:URL) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, options: [.mixWithOthers, .allowAirPlay, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let sessionError {
                print(sessionError)
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:musicMurl)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 1.0
                audioPlayer.play()
            }
        } catch {
            print(error)
        }
        
    }
    func startBackgroundMusic(musicMurl:URL) {
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, options: [.mixWithOthers, .allowAirPlay, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let sessionError {
                print(sessionError)
            }
            

            audioPlayer = try AVAudioPlayer(contentsOf:musicMurl)
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.play()
            
        } catch {
            print(error)
        }
        
    }
 
   
    func changeVolumBackgroundMusic(value:Float) {
           guard let audioPlayer = audioPlayer else { return }
           audioPlayer.volume = value
           
       }
    /**
        Mark: pause palying
       
     */
    func playBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.play()
    }
    func pauseBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.pause()
     }
    /**
        Mark: Stop palying
      
      */
    
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        print("Stoping background")
        audioPlayer.stop()
    }
    /**
           Mark:  make sound merging
   
     */
    
    var audioMixParams : [AnyObject] = [AnyObject]()
    func testSoundMerge(audioUrl1:URL,audioUrl2:URL,backGroundSoundVolume:Float,microPhoneSoundVolume:Float) -> URL{
        
        let composition = AVMutableComposition()
          print("Recording sound volume!!!!!!", microPhoneSoundVolume )
        
        //IMPLEMENT FOLLOWING CODE WHEN WANT TO MERGE ANOTHER AUDIO FILE
        //Add Audio Tracks to Composition
        let assetURL1 = audioUrl1
        setUpAndAddAudioAtPath(assetURL: assetURL1, composition: composition,SoundVolume:backGroundSoundVolume)
        let assetURL2 = audioUrl2
        setUpAndAddAudioAtPath(assetURL: assetURL2, composition: composition,SoundVolume:microPhoneSoundVolume)
        
        let audioMix:AVMutableAudioMix =  AVMutableAudioMix()
        audioMix.inputParameters = audioMixParams as! [AVAudioMixInputParameters]
        //If you need to query what formats you can export to, here's a way to find out
        print("compatible presets for songAsset:",AVAssetExportSession.exportPresets(compatibleWith: composition))
        let exporter:AVAssetExportSession = AVAssetExportSession.init(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
        exporter.audioMix = audioMix
        exporter.outputFileType = AVFileType.m4a
        //make destinationpath
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let fileName =  NSUUID().uuidString + ".m4a"
        let mergeAudioURL = documentDirectoryURL.appendingPathComponent(fileName)! as URL as NSURL
        exporter.outputURL = mergeAudioURL as URL
        
        exporter.exportAsynchronously(completionHandler:
            {
                switch exporter.status
                {
                case AVAssetExportSessionStatus.completed:
                    print("Success \(String(describing: exporter.outputURL))")
                case AVAssetExportSessionStatus.failed:
                    print("failed \(String(describing: exporter.error))")
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(String(describing: exporter.error))")
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(String(describing: exporter.error))")
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(String(describing: exporter.error))")
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(String(describing: exporter.error))")
                default:
                    print("Audio Concatenation Complete")
                }
        })
        
        return mergeAudioURL as URL
    }
    func setUpAndAddAudioAtPath(assetURL:URL,composition:AVMutableComposition,SoundVolume:Float){
        
        do{
            print("assetURL",assetURL)
            let songAsset:AVURLAsset = AVURLAsset(url: assetURL, options: nil)
            let track:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
            
            let sourceAudioTrack:AVAssetTrack = songAsset.tracks(withMediaType: AVMediaType.audio)[0]
            let tRange: CMTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: songAsset.duration)
            
            //Set Volume
            let trackMix:AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: track)
            //trackMix.setVolume(1.0, at: CMTime.zero)
            trackMix.setVolume(SoundVolume, at: CMTime.zero)
            audioMixParams.append(trackMix)
            
            //Insert audio into track
            //try! track.insertTimeRange(tRange, of: sourceAudioTrack, at: CMTimeMake(value: 0, timescale: 44100))
            //let range = CMTimeRangeMake(start: CMTime.zero, duration: songAsset.duration)
            let end = track.timeRange.end
            try track.insertTimeRange(tRange, of: sourceAudioTrack, at: end)
        }catch{
            print("=====================ERROR OCCURED========")
        }
        
  }
   
    func soundMerge(audioUrl1:URL,audioUrl2:URL) -> URL{
        let composition = AVMutableComposition()
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        compositionAudioTrack?.append(url: audioUrl1)//URL(fileURLWithPath:audioUrl1))//audioUrl1)
        compositionAudioTrack?.append(url: audioUrl2)// URL(fileURLWithPath:audioUrl2))
        var url = URL(fileURLWithPath:"")
        if let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) {
            assetExport.outputFileType = AVFileType.m4a
            
            
            let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
            let mergeAudioURL = documentDirectoryURL.appendingPathComponent("FinalAudio.m4a")! as URL as NSURL
            assetExport.outputURL = mergeAudioURL as URL
            assetExport.exportAsynchronously(completionHandler:
                {
                    switch assetExport.status
                    {
                    case AVAssetExportSessionStatus.failed:
                        print("failed \(String(describing: assetExport.error))")
                    case AVAssetExportSessionStatus.cancelled:
                        print("cancelled \(String(describing: assetExport.error))")
                    case AVAssetExportSessionStatus.unknown:
                        print("unknown\(String(describing: assetExport.error))")
                    case AVAssetExportSessionStatus.waiting:
                        print("waiting\(String(describing: assetExport.error))")
                    case AVAssetExportSessionStatus.exporting:
                        print("exporting\(String(describing: assetExport.error))")
                    default:
                        print("Audio Concatenation Complete")
                    }
            })
            url = mergeAudioURL as URL
        }
        return url
    }
   
}
extension AVMutableCompositionTrack {
    func append(url: URL) {
        let newAsset = AVURLAsset(url: url)
        let range = CMTimeRangeMake(start: CMTime.zero, duration: newAsset.duration)
        let end = timeRange.end
        print(end)
        if let track = newAsset.tracks(withMediaType: AVMediaType.audio).first {
            print("TRACK++++++++++++",track)
            try! insertTimeRange(range, of: track, at: end)
        }
        
    }
}
/**
          Mark: Class for Recorder
  
*/
protocol CustomAudioRecorderDelegate:NSObjectProtocol {
    func didOKPressed(_ fileName:String?,audioURL : URL ,view:RecorderClass)
    //func didCancelPressed(view:CustomAudioPlayLayout)
}
class RecorderClass:UIView,AVAudioRecorderDelegate{
    //var recordingSession: AVAudioSession!
    //var whistleRecorder: AVAudioRecorder!
    
    var delegate: CustomAudioRecorderDelegate? = nil
    var fileName = NSUUID().uuidString + ".wav"
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var settings         = [String : Int]()
    
    static let shared = RecorderClass()
    func requestForRecordPermission() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            //try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)  //Working
            
            
            try? recordingSession.setCategory(.playAndRecord, options:.mixWithOthers)
           
            
            
            
            //try recordingSession.setCategory(AVAudioSession.Category.record)  //Working
            //try recordingSession.setCategory(AVAudioSession.Category.playback)
            //try recordingSession.setCategory(AVAudioSession.Category.multiRoute)
            //AVAudioSession.CategoryOptions.mixWithOthers
            
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Allow For Recording!!!!")
                    } else {
                        print("Dont Allow For Recording!!!!")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
        
        // Audio Settings
        //Int(kAudioFormatMPEG4AAC),
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
    }
    func startRecord(){
        if audioRecorder == nil {
             self.startRecording()
        } else {
            audioRecorder.stop()
        }
    }
    func endRecord(){
        if audioRecorder == nil {
        }
        else{
            self.finishRecording(success: true)
        }
    }
}
extension RecorderClass {
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(fileName)
        
        return soundURL as NSURL?
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func startRecording() {
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let settings: [String : AnyObject] = [
            AVFormatIDKey:Int(kAudioFormatLinearPCM) as AnyObject,
            AVSampleRateKey:44100.0 as AnyObject,
            AVNumberOfChannelsKey:1 as AnyObject,
            AVLinearPCMBitDepthKey:8 as AnyObject,
            AVLinearPCMIsFloatKey:false as AnyObject,
            AVLinearPCMIsBigEndianKey:false as AnyObject,
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue as AnyObject
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record()
            
        } catch {
            finishRecording(success: false)
        }
        
    }
    func finishRecording(success: Bool) {
        if(audioRecorder != nil){
            audioRecorder.stop()
        }
        
        
        if success {
            print(success)
            if let delegate = self.delegate {
                let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
                audioRecorder = nil
                print("Record Save to ::", audioFilename)
                delegate.didOKPressed(fileName, audioURL: audioFilename, view: self)
            }
            
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
  
}

   /*
   func merge(audio1: NSURL, audio2:  NSURL) {


       var error:NSError?

       var ok1 = false
       var ok2 = false


       //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
       var composition = AVMutableComposition()
       var compositionAudioTrack1:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())!
       var compositionAudioTrack2:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())!

       //create new file to receive data
       var documentDirectoryURL = FileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as! NSURL
       var fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("resultmerge.wav")
  
       var url1 = audio1
       var url2 = audio2


       var avAsset1 = AVURLAsset(URL: url1, options: nil)
       var avAsset2 = AVURLAsset(URL: url2, options: nil)

       var tracks1 =  avAsset1.tracksWithMediaType(AVMediaTypeAudio)
       var tracks2 =  avAsset2.tracksWithMediaType(AVMediaTypeAudio)

       var assetTrack1:AVAssetTrack = tracks1[0] as! AVAssetTrack
       var assetTrack2:AVAssetTrack = tracks2[0] as! AVAssetTrack


       var duration1: CMTime = assetTrack1.timeRange.duration
       var duration2: CMTime = assetTrack2.timeRange.duration

       var timeRange1 = CMTimeRangeMake(start: CMTime.zero, duration: duration1)
       var timeRange2 = CMTimeRangeMake(start: duration1, duration: duration2)


       ok1 = compositionAudioTrack1.insertTimeRange(timeRange1, ofTrack: assetTrack1, atTime: kCMTimeZero, error: nil)
       if ok1 {

           ok2 = compositionAudioTrack2.insertTimeRange(timeRange2, ofTrack: assetTrack2, atTime: duration1, error: nil)

           if ok2 {
               print("success")
           }
       }

       //AVAssetExportPresetPassthrough => concatenation
       var assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough)
       assetExport?.outputFileType = AVFileType.m4a
       assetExport.outputURL = fileDestinationUrl
       assetExport?.exportAsynchronously(completionHandler: {
           switch assetExport?.status{
           case  .failed:
               print("failed \(String(describing: assetExport?.error))")
           case .cancelled:
               print("cancelled \(String(describing: assetExport?.error))")
           default:
               print("complete")
               var audioPlayer = AVAudioPlayer()
               audioPlayer = AVAudioPlayer(contentsOfURL: fileDestinationUrl, error: nil)
               audioPlayer.prepareToPlay()
               audioPlayer.play()
           }

       })

   }
   */
   
 
   
   
   
   /*
       - (IBAction)saveRecording
           {
                AVMutableComposition *composition = [AVMutableComposition composition];
                   audioMixParams = [[NSMutableArray alloc] initWithObjects:nil];

               //IMPLEMENT FOLLOWING CODE WHEN WANT TO MERGE ANOTHER AUDIO FILE
               //Add Audio Tracks to Composition
               NSString *URLPath1 = [[NSBundle mainBundle] pathForResource:@"mysound" ofType:@"mp3"];
               NSString *URLPath2 = [[NSBundle mainBundle] pathForResource:@"mysound2" ofType:@"mp3"];
               NSURL *assetURL1 = [NSURL fileURLWithPath:URLPath1];
               [self setUpAndAddAudioAtPath:assetURL1   toComposition:composition];

               NSURL *assetURL2 = [NSURL fileURLWithPath:URLPath2];
               [self setUpAndAddAudioAtPath:assetURL2   toComposition:composition];

               AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
               audioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];

               //If you need to query what formats you can export to, here's a way to find out
               NSLog (@"compatible presets for songAsset: %@",
                      [AVAssetExportSession exportPresetsCompatibleWithAsset:composition]);

               AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                                 initWithAsset: composition
                                                 presetName: AVAssetExportPresetAppleM4A];
               exporter.audioMix = audioMix;
               exporter.outputFileType = @"com.apple.m4a-audio";
               NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
               exporter.outputURL = exportURL;

           // do the export
                   [exporter exportAsynchronouslyWithCompletionHandler:^{
                       int exportStatus = exporter.status;
                       NSError *exportError = exporter.error;

                       switch (exportStatus) {
                           case AVAssetExportSessionStatusFailed:

                               break;

                           case AVAssetExportSessionStatusCompleted: NSLog (@"AVAssetExportSessionStatusCompleted");
                               break;
                           case AVAssetExportSessionStatusUnknown: NSLog (@"AVAssetExportSessionStatusUnknown"); break;
                           case AVAssetExportSessionStatusExporting: NSLog (@"AVAssetExportSessionStatusExporting"); break;
                           case AVAssetExportSessionStatusCancelled: NSLog (@"AVAssetExportSessionStatusCancelled"); break;
                           case AVAssetExportSessionStatusWaiting: NSLog (@"AVAssetExportSessionStatusWaiting"); break;
                           default:  NSLog (@"didn't get export status"); break;
                       }
                   }];
            }
           
        */

 
 /*
 func mergeAudioFiles(audioFileUrls: NSArray)  -> URL  {
     let composition = AVMutableComposition()

     for i in 0 ..< audioFileUrls.count {

         let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!

         //let asset = AVURLAsset(url: (audioFileUrls[i] as! NSURL) as URL)
         let asset = AVURLAsset(url: URL(fileURLWithPath: audioFileUrls[i] as! String))
         let track = asset.tracks(withMediaType: AVMediaType.audio)[0]
         
         let timeRange = CMTimeRange(start: CMTimeMake(value: 0, timescale: 600), duration: track.timeRange.duration)

         try! compositionAudioTrack.insertTimeRange(timeRange, of: track, at: composition.duration)
     }

     let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
     let mergeAudioURL = documentDirectoryURL.appendingPathComponent("FinalAudio.m4a")! as URL as NSURL

     let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
     assetExport?.outputFileType = AVFileType.m4a
     assetExport?.outputURL = mergeAudioURL as URL
     assetExport?.exportAsynchronously(completionHandler:
         {
             switch assetExport!.status
             {
             case AVAssetExportSessionStatus.failed:
                 print("failed \(String(describing: assetExport?.error))")
             case AVAssetExportSessionStatus.cancelled:
                 print("cancelled \(String(describing: assetExport?.error))")
             case AVAssetExportSessionStatus.unknown:
                 print("unknown\(String(describing: assetExport?.error))")
             case AVAssetExportSessionStatus.waiting:
                 print("waiting\(String(describing: assetExport?.error))")
             case AVAssetExportSessionStatus.exporting:
                 print("exporting\(String(describing: assetExport?.error))")
             default:
                 print("Audio Concatenation Complete")
             }
     })
     return mergeAudioURL as URL
 }
 func mergeSound(soundFiles: [String],outputFile:String) -> String  {
     var startTime: CMTime = CMTime.zero
     let composition: AVMutableComposition = AVMutableComposition()
     let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
     
     
     
     
     print(soundFiles)
     
     
     for fileNameUrl in soundFiles {
         let url: URL = URL(fileURLWithPath: fileNameUrl)
         let avAsset: AVURLAsset = AVURLAsset(url: url)
         let timeRange: CMTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: avAsset.duration)
            
         //let audioTrack: AVAssetTrack = avAsset.tracks(withMediaType: AVMediaType.audio)[0]
     let audioTrack: AVAssetTrack = avAsset.tracks(withMediaType: .audio).first!
         //tracks(withMediaType: <#T##AVMediaType#>)
         try! compositionAudioTrack.insertTimeRange(timeRange, of: audioTrack, at: startTime)
         startTime = CMTimeAdd(startTime, timeRange.duration)
         
     }
   
     let exportPath: String = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path+"/"+outputFile+".m4a"
     
     let export: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
     
     export.outputURL = URL(fileURLWithPath: exportPath)
     export.outputFileType = AVFileType.m4a
     
     export.exportAsynchronously {
         if export.status == AVAssetExportSession.Status.completed {
             NSLog("All done");
             
         }
     }
     return exportPath
 }
 */
    
       
    /*  - (void) setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition *)composition
       {
           AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];

           AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
           AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];

           NSError *error = nil;
           BOOL ok = NO;

           CMTime startTime = CMTimeMakeWithSeconds(0, 1);
           CMTime trackDuration = songAsset.duration;
           //CMTime longestTime = CMTimeMake(848896, 44100); //(19.24 seconds)
           CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);

           //Set Volume
           AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
           [trackMix setVolume:0.8f atTime:startTime];
           [self.audioMixParams addObject:trackMix];

           //Insert audio into track
           ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:CMTimeMake(0, 44100) error:&error];
       }
*/
   
    
    
    
    
    
    
    
   
    
    
    
    
    
    
    
