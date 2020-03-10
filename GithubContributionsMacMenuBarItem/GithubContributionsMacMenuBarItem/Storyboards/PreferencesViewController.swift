//
//  PreferencesViewController.swift
//  GithubContributionsMacMenuBarItem
//
//  Created by Ankith on 3/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa


class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var stylePopUp: NSPopUpButton!
    
    @IBOutlet weak var CyclePopUp: NSPopUpButton!
    private let ds = DataStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.stringValue = ds.username
        CyclePopUp.selectItem(withTag: ds.cycle)
        stylePopUp.selectItem(at: ds.style == .mono ? 0 : 1)
    }
    
    @IBAction func cycleChange(_ sender: NSPopUpButton) {
        ds.cycle = sender.selectedTag()
        AppDelegate.shared.stopTimer()
        AppDelegate.shared.startTimer()
    }
    
    @IBAction func styleChange(_ sender: NSPopUpButton) {
        ds.style = Style(rawValue: sender.indexOfSelectedItem)!
    }
   
    
}

extension PreferencesViewController: NSTextFieldDelegate {
    
    func controlTextDidEndEditing(_ obj: Notification) {
        ds.username = textField.stringValue
        AppDelegate.shared.fetchData()
    }
    
}

class PreferencesWindow: NSWindow {
    
    override func cancelOperation(_ sender: Any?) {
        self.close()
    }
}
