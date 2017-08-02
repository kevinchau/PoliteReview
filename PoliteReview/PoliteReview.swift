//
//  PoliteReview.swift
//  PoliteReview
//
//  Created by Kevin Chau on 8/1/17.
//  Copyright © 2017 likelylabs. All rights reserved.
//

import Foundation

 enum UserDefaultKeys: String {
    case politeReviewTotalLaunchCount
    case politeReviewVersionLaunchCount
    case politeReviewReviewedVersion
    case politeReviewHasReviewed
}

public class PoliteReview {
    
    static private(set) var storeID: String = ""
    static private(set) var contactURL: String = ""
    static private(set) var contactEmail: String = ""
    static private(set) var triggerCount: Int = 5
    static public let main = PoliteReview()
    
    public func setup(itunesID: String, contactURL: String, contactEmail: String, triggerCount: Int = 5) {
        PoliteReview.storeID = itunesID
        PoliteReview.contactURL = contactURL
        PoliteReview.contactEmail = contactEmail
        PoliteReview.triggerCount = triggerCount
        incrementTotalLaunch()
        incrementVersionLaunch()
    }
    
    private init() {
        // init is private to force use of singleton
    }
    
    private func incrementTotalLaunch() {
        // Keep track of how many times the app has been launched
        let totalLaunchCount = UserDefaults.standard.integer(forKey: UserDefaultKeys.politeReviewTotalLaunchCount.rawValue)
        UserDefaults.standard.set(totalLaunchCount + 1, forKey: UserDefaultKeys.politeReviewTotalLaunchCount.rawValue)
    }
    
    private func incrementVersionLaunch() {
        let currentVersion = getVersion()
        
        // Reset the counter if the current app version is newer than a previous reviewed version
        if let storedVersion = UserDefaults.standard.string(forKey: UserDefaultKeys.politeReviewReviewedVersion.rawValue) {
            if currentVersion.compare(storedVersion, options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending {
                UserDefaults.standard.set(0, forKey: UserDefaultKeys.politeReviewVersionLaunchCount.rawValue)
            }
        }
        
        // Keep track of how many times this particular version has been launched
        let currentCount = UserDefaults.standard.integer(forKey: UserDefaultKeys.politeReviewVersionLaunchCount.rawValue)
        UserDefaults.standard.set(currentCount + 1, forKey: UserDefaultKeys.politeReviewVersionLaunchCount.rawValue)
    }
    
    func shouldPresent() -> Bool {
        // Determines if a review should be presented based on a new version and if the user has been prompted before
        var should = false
        let currentVersion = getVersion()
        let hasReviewed = UserDefaults.standard.bool(forKey: UserDefaultKeys.politeReviewHasReviewed.rawValue)
        let versionCount = UserDefaults.standard.integer(forKey: UserDefaultKeys.politeReviewVersionLaunchCount.rawValue)
        
        if versionCount >= PoliteReview.triggerCount {
            if let storedVersion = UserDefaults.standard.string(forKey: "reviewVersion") {
                if currentVersion.compare(storedVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending {
                    should = true
                }
            }
            else if hasReviewed == false {
                should = true
            }
        }
        return should
    }
    
    func getVersion() -> String {
        // Get current app version string
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "0.0.0"
        }
        return version
    }
}
