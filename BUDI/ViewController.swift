//
//  ViewController.swift
//  TransferDataPhoneWatchFeb
//
//  Created by Blynn Shideler on 2/21/21.
//  Copyright © 2021 Blynn L Shideler. All rights reserved.
//

import UIKit
import WatchConnectivity

import CoreMotion

class ViewController: UIViewController {
    
    let manager = CMMotionManager()
    
    
    var session: WCSession?
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureWatchKitSession()
    }
    
    func configureWatchKitSession() {
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    @IBAction func tapSendDataToWatch(_ sender: Any) {
        
        if let validSession = self.session, validSession.isReachable {
            let data: [String: Any] = ["iPhone": "Data from iPhone" as Any]
            validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
        }
    }
}

    extension ViewController: WCSessionDelegate {
        
        func sessionDidBecomeInactive(_ session: WCSession) {
        }
        
        func sessionDidDeactivate(_ session: WCSession) {
        }
        
        func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        }
        
        func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
            print("received message: \(message)")
            DispatchQueue.main.async{
                if let value = message["watch"] as? String {
                    self.label.text = value
                }
            }
        }
    }



