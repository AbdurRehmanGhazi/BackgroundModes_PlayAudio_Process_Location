//
//  ViewController.swift
//  BackgroundModes
//
//  Created by AbdurRehmanNineSol on 13/09/2022.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var timer: Timer?
    @Published var isPlaying = false
    var audioPlayer: AVAudioPlayer?
    var timeCounter: Int = 0
    var airPlay = UIView()
    
    
    static var songs: [URL] = {
        // find the mp3 song files in the bundle and return player item for each
        let songList = ["FeelinGood", "IronBacon", "WhatYouWant"]
        return songList.map {
            guard let url = Bundle.main.url(forResource: $0, withExtension: "mp3") else {
                return nil
            }
            return url
        }
        .compactMap { $0 }
    }()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupAirPlayBtn()
        guard let url = Bundle.main.url(forResource: "FeelinGood", withExtension: "mp3") else { return }

           do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
               try AVAudioSession.sharedInstance().setActive(true)

               audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

               audioPlayer?.volume = 1

           } catch let error {
               print(error.localizedDescription)
           }
        
        let navBtn = UIBarButtonItem(customView: airPlay)
        self.navigationItem.rightBarButtonItem = navBtn
    }


    
    @objc func fireTimer() {
        timeCounter += 1
        let currentTime1 = Int((audioPlayer?.currentTime)!)
        let minutes = currentTime1/60
        let seconds = currentTime1 - minutes * 60
        
        if UIApplication.shared.applicationState == .active {
            timeLabel.text  = NSString(format: "%02d:%02d", minutes,seconds) as String
        } else {
            print("App is playing in background mode : \(timeCounter)")
        }
    }

    @IBAction func tapPlayPauseBtn(_ sender: UIButton) {
        songName.text = "FeelinGood"
        if sender.titleLabel?.text == "Play" {
            sender.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            audioPlayer?.play()
        } else {
            sender.setTitle("Play", for: .normal)
            timer?.invalidate()
            audioPlayer?.pause()
        }
    }
    
    func setupAirPlayBtn() {
        airPlay.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let routerPickerView = AVRoutePickerView(frame: buttonView.bounds)
        routerPickerView.tintColor = .black
        routerPickerView.activeTintColor = .green
        buttonView.addSubview(routerPickerView)
        self.airPlay.addSubview(buttonView)
    }
    
}


class AppConstant: NSObject {
    
    // MARK: - Network & Third party
    
    static let baseUrl              =   "https://translate.googleapis.com/"
    
    
     func didTranslateText(text: String, from: String, to: String, completion: @escaping (_ result: String) -> Void) {
        
        let fromLang = "\(from)"
        let toLang = "\(to)"
        
        //        TranslateText.init(text: text, from: fromLang, to: toLang)
        var texts = text
    
        texts = texts.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let baseUrl1 = "\(AppConstant.baseUrl)translate_a/single?client=gtx&ie=UTF-8&oe=UTF-8&sl=\(fromLang)&tl=\(toLang)&dt=t&q=\(texts)"
       
        
        let url = URL(string: baseUrl1)
        let request = URLRequest(url: url!)
        print("Session start")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                completion("error")
                return
            }
            print(data)
            let responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(String(describing: responseString))")
            
            let resultArr:Array = responseString.components(separatedBy: "],[")
            let count = resultArr.count - 1
            var resultString = ""
            print(resultArr.count)
            
            for i in 0...count {
                if resultArr[i].prefix(1) == "\"" || i == 0 {
                let temp = resultArr[i].components(separatedBy: "\"")
                resultString.append(temp[1])
                }
            }
            
            DispatchQueue.main.async {
                completion(resultString)
                print(resultString)
            }
            }.resume()
        print("session end")
    }
}


//
//override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//
////        DispatchQueue.main.async {
//////            let obj = AppConstant()
//////
//////            obj.didTranslateText(text: "HOw are YOu", from: "en-US", to: "ar-SA") { result in
////                print(result)
////            }
//
////        var text = "How are you budy. Are you feeling well"
////        text = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
////        let url1 = URL(string: "https://translate.googleapis.com/translate_a/single?client=gtx&ie=UTF-8&oe=UTF-8&sl=en-US&tl=ar-SA&dt=t&q=H\(text)")
////        var request = URLRequest(url: url1!)
////        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        request.httpMethod = "GET"
////        URLSession.shared.dataTask(with: request) { data, response, error in
////            let str = String(data: data!, encoding: .utf8)
////            print(str)
////        }.resume()
//
//}
