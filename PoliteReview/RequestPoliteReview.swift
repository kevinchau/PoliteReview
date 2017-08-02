//
//  RequestPoliteReview.swift
//  PoliteReview
//
//  Created by Kevin Chau on 8/1/17.
//  Copyright © 2017 likelylabs. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    public func requestPoliteReview() {
        // Presents a UIAlertController for the initial prompt
        let appName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"]
        
        let alertController = UIAlertController(title: String("\(NSLocalizedString("Do you love", comment: "For the alert controller preceding the app name")) \(appName ?? "this app")?"), message: NSLocalizedString("Give Us Your Feedback", comment: "Message for the alert controller"), preferredStyle: .alert)
        
        // They love it action
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: "Alert Action"), style: .default) { (UIAlertAction) in
            
            // Sets the reviewed status and sets the reviewed version
            self.setUserDefaultsHasReviewed()
            
            // Requests a review via the StoreKit alert, or legacy if 10.3 is not available
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                self.legacyAlert()
            }
        }
        
        // They Don't love it action
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: "Alert Action"), style: .cancel) { (UIAlertAction) in
            // Sets the reviewed status and sets the reviewed version
            self.setUserDefaultsHasReviewed()
            // Initiates the contact process
            self.contact()
        }
        
        // Adds the actions to the alert controller
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        if PoliteReview.main.shouldPresent() == true {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    private func legacyAlert() {
        // Legacy alert prompts user to write a review if they are below 10.3
        let legacyAlertController = UIAlertController(title: NSLocalizedString("Thank You!", comment: "Message when user love app"), message: NSLocalizedString("Please Consider Writing a Review", comment: "Ask legacy user for review"), preferredStyle: .alert)
        // Action to write a review
        let legacyWriteAction = UIAlertAction(title: NSLocalizedString("Write Review", comment: "Alert Action"), style: .default) { (UIAlertAction) in
            let openAppStoreForRating = "itms-apps://itunes.apple.com/us/app/id\(PoliteReview.storeID)?action=write-review&mt=8"
            if UIApplication.shared.canOpenURL(URL(string: openAppStoreForRating)!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: openAppStoreForRating)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: openAppStoreForRating)!)
                }
            }
        }
        // Action to not write a review
        let legacyDeclineAction = UIAlertAction(title: NSLocalizedString("Not Now", comment: "Alert Action"), style: .cancel, handler: nil)
        // Adds the actions to the alert controller
        legacyAlertController.addAction(legacyWriteAction)
        legacyAlertController.addAction(legacyDeclineAction)
        
        present(legacyAlertController, animated: true, completion: nil)
    }
    
    private func contact() {
        let alertController = UIAlertController(title: NSLocalizedString("Oh No!", comment: "Alert title when user does not love your app"), message: NSLocalizedString("Let us know how to improve.", comment: "Message when user does not love your app"), preferredStyle: .alert)
        let contactAction = UIAlertAction(title: NSLocalizedString("Send Feedback", comment: "alert action"), style: .default) { (UIAlertAction) in
            let appName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"]
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                // Configure the fields of the interface.
                composeVC.setToRecipients([PoliteReview.contactEmail])
                composeVC.setSubject("Contact from \(appName ?? "iOS App")")
                composeVC.setMessageBody("Message: ", isHTML: false)
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            } else {
                guard let url = URL(string: PoliteReview.contactURL) else {
                    return
                }
                if UIApplication.shared.canOpenURL(url){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
        let declineContactAction = UIAlertAction(title: NSLocalizedString("Not Now", comment: "Alert Action"), style: .cancel) { (UIAlertAction) in
            // stuff here
        }
        alertController.addAction(contactAction)
        alertController.addAction(declineContactAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setUserDefaultsHasReviewed() {
        // Sets the reviewed status and sets the reviewed version
        let currentVersion = PoliteReview.main.getVersion()
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.politeReviewHasReviewed.rawValue)
        UserDefaults.standard.set(currentVersion, forKey: UserDefaultKeys.politeReviewReviewedVersion.rawValue)
    }
    
}
