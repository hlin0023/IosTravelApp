//
//  SignViewController.swift
//  Tripo
//
//  Created by lin on 25/4/2023.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseFirestoreSwift


class SignViewController: UIViewController, DatabaseListener {
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .user
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    
    @IBOutlet weak var videoLayer: UIView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func login(_ sender: Any) {
        let uEmail = userName.text
        let uPass = userPassword.text
        
        // validate the inputs
        if let uEmail = uEmail, let uPass = uPass {
            
            if uEmail.isEmpty == false && uPass.isEmpty == false && isValidEmailAddr(strToValidate: uEmail) == true{
               databaseController?.logUser(email: uEmail, password: uPass)
                //self.performSegue(withIdentifier: "signinSegue", sender: nil)
               return
           }
            else {
                var errorMsg = "Please ensure all fields are filled:\n"
                if uEmail.isEmpty {
                    errorMsg += "- Must provide a email\n"
                }
                if uPass.isEmpty {
                    errorMsg += "- Must provide a password\n"
                }
                if isValidEmailAddr(strToValidate: uEmail) == false{
                    errorMsg += "- Must provide a valid email adress\n"
                }
                displayErrorMessage(title: "Error", message: errorMsg)
           }
       }
    }
    
    @IBAction func signup(_ sender: Any) {
        let uEmail = userName.text
        let uPass = userPassword.text
        
        // validate the inputs
        if let uEmail = uEmail, let uPass = uPass {
            
            if uEmail.isEmpty == false && uPass.isEmpty == false && isValidEmailAddr(strToValidate: uEmail) == true{
               databaseController?.signUser(email: uEmail, password: uPass)
               return
           }
            else {
                var errorMsg = "Please ensure all fields are filled:\n"
                if uEmail.isEmpty {
                    errorMsg += "- Must provide a email\n"
                }
                if uPass.isEmpty {
                    errorMsg += "- Must provide a password\n"
                }
                if isValidEmailAddr(strToValidate: uEmail) == false{
                    errorMsg += "- Must provide a valid email adress\n"
                }
                displayErrorMessage(title: "Error", message: errorMsg)
           }
       }
    }
    
    // referene: get validate email method from https://www.abstractapi.com/guides/validate-email-in-swift
    func isValidEmailAddr(strToValidate: String) -> Bool {
      let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"  // 1

      let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)  // 2

      return emailValidationPredicate.evaluate(with: strToValidate)  // 3
    }
    
    func displayErrorMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message,preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func onUserChange(change: DatabaseChange, status: Bool, errorMsg:String?) {
        print("onUserChange")
        Auth.auth().addStateDidChangeListener{ auth,user in
            if let user = user {
                print(user)
                if status == true {
                    print("seg")
                    self.performSegue(withIdentifier: "signinSegue", sender: nil)
                }
                else if errorMsg?.isEmpty == false{
                    print("sef error")
                    self.displayErrorMessage(title: "Error", message: errorMsg!)
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    override func viewDidLoad() {
               
        super.viewDidLoad()
        playBgmVideo()
        print("viewload")

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
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
