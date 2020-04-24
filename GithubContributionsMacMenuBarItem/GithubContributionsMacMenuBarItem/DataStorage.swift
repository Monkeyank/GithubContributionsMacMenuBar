//
//  DataStorage.swift
//  GithubContributionsMacMenuBarItem
//
//  Created by Ankith on 3/5/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class DataStorage {
    
    // Storing and managing username
    static let shared = DataStorage()
    
    private let userDefaults = UserDefaults.standard
    
    var username: String {
        get { return userDefaults.string(forKey: "username")! }
        set { userDefaults.set(newValue, forKey: "username") }
    }
    
    var cycle: Int {
        get { return userDefaults.integer(forKey: "cycle") }
        set { userDefaults.set(newValue, forKey: "cycle") }
    }
    
    // Style preferences being saved
    var color: Color {
        get { return Color(rawValue: userDefaults.integer(forKey: "color"))! }
        set { userDefaults.set(newValue.rawValue, forKey: "color") }
    }
    
    var style: Style {
        get { return Style(rawValue: userDefaults.integer(forKey: "style"))! }
        set { userDefaults.set(newValue.rawValue, forKey: "style") }
    }
    
    // Storing and intializing User Defaults
    private init() {
        userDefaults.register(defaults: ["username" : "",
                                         "cycle" : 5,
                                         "color" : Color.mono.rawValue,
                                         "style" : Style.block.rawValue])
    }
    
}
