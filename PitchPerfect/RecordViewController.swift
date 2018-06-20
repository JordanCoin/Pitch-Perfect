//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Jordan Jackson on 10/9/17.
//  Copyright © 2017 Jordan Jackson. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(recording: false)
    }
    
    // MARK: - Configure UI
    
    func configureUI(recording: Bool) {
        stopButton.isEnabled = recording
        recordButton.isEnabled = !recording
    }

    @IBAction func recordButtonPressed(_ sender: Any) {
        
        configureUI(recording: true)
        
        // create the file path for the recording.
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        // create a new audio session instance.
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        // initalize the audio recorder.
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        
        configureUI(recording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "PlayViewController", sender: audioRecorder.url)
        } else {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayViewController" {
            let playVC = segue.destination as! PlayViewController
            let recordedAudioURL = sender as! URL
            playVC.recordedAudioURL = recordedAudioURL
        }
    }
}

