//
//  InterfaceController.swift
//  TransferDataPhoneWatchFeb WatchKit Extension
//
//  Created by Blynn Shideler on 2/21/21.
//  Copyright © 2021 Blynn L Shideler. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import UserNotifications

import CoreMotion


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var label: WKInterfaceLabel!//**2
    let session = WCSession.default//**3
    
    let watchmanager = CMMotionManager()
    
    @IBAction func beginData() {
        watchmanager.startAccelerometerUpdates()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let data = self.watchmanager.accelerometerData {
                let accx = data.acceleration.x
                let accy = data.acceleration.y
                let accz = data.acceleration.z
                
        
            }
        }
    }
    
    @IBAction func beginNoti() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        print("notifications have begun")

    }
    
    
    @IBAction func stopNoti() {
        let center = UNUserNotificationCenter.current()

//               let content = UNMutableNotificationContent()
//               content.title = "gnite sleep tite"
//               content.body = "The notifications have now been silenced. Carry on then."
//               content.categoryIdentifier = "alarm"
//               content.userInfo = ["customData": "fizzbuzz"]
//               content.sound = UNNotificationSound.default
//
//               var dateComponents = DateComponents()
//               dateComponents.hour = 10
//               dateComponents.minute = 30
//               let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//               let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.removeAllPendingNotificationRequests()
               //center.add(request)
            
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        session.delegate = self//**4
        session.activate()//**5
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    @IBAction func tapSendToiPhone() {//**6
       let data: [String: Any] = ["watch": "data received from watch" as Any] //Create your dictionary as per uses
       session.sendMessage(data, replyHandler: nil, errorHandler: nil) //**6.1
     }
    
    @IBAction func tapResetDataiPhone() {//**6
      let data: [String: Any] = ["watch": "data reset" as Any] //Create your dictionary as per uses
      session.sendMessage(data, replyHandler: nil, errorHandler: nil) //**6.1
    }
    
    @IBAction func openMainMenu() {
        self.pushController(withName: "mainMenu", context: nil)
    }
    
    
    
    @IBAction func openMainPhoneMenu() {
        self.pushController(withName: "mainPhoneMenu", context: nil)
    }
    
    

}

extension InterfaceController: WCSessionDelegate {
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    
    print("received data: \(message)")
    if let value = message["iPhone"] as? String {//**7.1
      self.label.setText(value)
    }
  }
}
