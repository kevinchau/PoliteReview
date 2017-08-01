//
//  PoliteReview.swift
//  PoliteReview
//
//  Created by Kevin Chau on 8/1/17.
//  Copyright © 2017 likelylabs. All rights reserved.
//

import Foundation


internal enum UserDefaultKeys: String {
    case PoliteReviewTotalLaunchCount
    case PoliteReviewVersionLaunchCount
    case PoliteReviewReviewedVersion
    case PoliteReviewHasReviewed
}

public class PoliteReview {
    
    static private(set) internal var storeID: String = ""
    static private(set) internal var contactURL: String = ""
    static private(set) internal var contactEmail: String = ""
    static private(set) var triggerCount: Int = 5
    
    public func setup(itunesID: String, contactURL: String, contactEmail: String, triggerCount: Int = 5) {
        PoliteReview.storeID = itunesID
        PoliteReview.contactURL = contactURL
        PoliteReview.contactEmail = contactEmail
        incrementTotalLaunch()
        incrementVersionLaunch()
    }
    
    public init() {
        
    }
    
    private func incrementTotalLaunch() {
        // Keep track of how many times the app has been launched
        let totalLaunchCount = UserDefaults.standard.integer(forKey: UserDefaultKeys.PoliteReviewTotalLaunchCount.rawValue)
        UserDefaults.standard.set(totalLaunchCount + 1, forKey: UserDefaultKeys.PoliteReviewTotalLaunchCount.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    private func incrementVersionLaunch() {
        let currentVersion = getVersion()
        
        // Reset the counter if the current app version is newer than a previous reviewed version
        if let storedVersion = UserDefaults.standard.string(forKey: UserDefaultKeys.PoliteReviewReviewedVersion.rawValue) {
            if currentVersion.compare(storedVersion, options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending {
                UserDefaults.standard.set(0, forKey: UserDefaultKeys.PoliteReviewVersionLaunchCount.rawValue)
            }
        }
        
        // Keep track of how many times this particular version has been launched
        let currentCount = UserDefaults.standard.integer(forKey: UserDefaultKeys.PoliteReviewVersionLaunchCount.rawValue)
        UserDefaults.standard.set(currentCount + 1, forKey: UserDefaultKeys.PoliteReviewVersionLaunchCount.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    internal func shouldPresent() -> Bool {
        // Determines if a review should be presented based on a new version and if the user has been prompted before
        var should = false
        let currentVersion = getVersion()
        let hasReviewed = UserDefaults.standard.bool(forKey: UserDefaultKeys.PoliteReviewHasReviewed.rawValue)
        let versionCount = UserDefaults.standard.integer(forKey: UserDefaultKeys.PoliteReviewVersionLaunchCount.rawValue)
        
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
    
    internal func getVersion() -> String {
        // Get current app version string
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "0.0.0"
        }
        return version
    }
}
