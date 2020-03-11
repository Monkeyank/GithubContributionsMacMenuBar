//
//  DataStorage.swift
//  GithubContributionsMacMenuBarItem
//
//  Created by Ankith on 3/5/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class DataStorage {
    
    static let shared = DataStorage()
    
    private let userDefaults = UserDefaults.standard
    
    // Storing and managing username
    var username: String {
        get {
            return userDefaults.string(forKey: "username")!
        }
        set(newName) {
            userDefaults.set(newName, forKey: "username")
            userDefaults.synchronize()
        }
    }
    
    var cycle: Int {
        get {
            return userDefaults.integer(forKey: "cycle")
        }
        set(newCycle) {
            userDefaults.set(newCycle, forKey: "cycle")
            userDefaults.synchronize()
        }
    }
    
    // Style preferences being saved
    
    var style: Style {
        get {
            return Style(rawValue: userDefaults.integer(forKey: "style"))!
        }
        set(newStyle) {
            userDefaults.set(newStyle.rawValue, forKey: "style")
            userDefaults.synchronize()
        }
    }
    
    // Storing and intializing User Defaults
    private init() {
        userDefaults.register(defaults: ["username" : "",
                                         "cycle" : 5,
                                         "style" : Style.green.rawValue])
    }
    
}
