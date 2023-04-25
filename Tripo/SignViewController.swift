//
//  SignViewController.swift
//  Tripo
//
//  Created by lin on 25/4/2023.
//

import UIKit
import AVFoundation

class SignViewController: UIViewController {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    
    @IBOutlet weak var videoLayer: UIView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    //var paused: Bool = false

    override func viewDidLoad() {
               
        super.viewDidLoad()
        playBgmVideo()
        print("viewload")

        // Do any additional setup after loading the view.
    }
    
    func playBgmVideo(){
        guard let videoPath = Bundle.main.path(forResource: "sign", ofType: "mp4")else{
            print("play video not found")
            return
        }
        
        print("play video")
        avPlayer = AVPlayer(url: URL(fileURLWithPath: videoPath))
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        avPlayerLayer.frame = self.view.bounds
        avPlayerLayer.videoGravity = .resizeAspectFill
        
        self.videoLayer.layer.addSublayer(avPlayerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)),name: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        avPlayer.play()
    }
    

    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero)
        avPlayer.play()
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
