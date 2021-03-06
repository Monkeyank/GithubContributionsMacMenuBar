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
    @IBOutlet weak var colorPopUp: NSPopUpButton!
    @IBOutlet weak var cyclePopUp: NSPopUpButton!
    private let ds = DataStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.stringValue = ds.username
        cyclePopUp.selectItem(withTag: ds.cycle)
        colorPopUp.selectItem(at: ds.color.rawValue)
        stylePopUp.selectItem(at: ds.style.rawValue)
    }
    
    @IBAction func colorChange(_ sender: NSPopUpButton) {
        ds.color = Color(rawValue: sender.indexOfSelectedItem)!
        AppDelegate.shared.updateData()
    }
    
    @IBAction func cycleChange(_ sender: NSPopUpButton) {
        ds.cycle = sender.selectedTag()
        AppDelegate.shared.stopTimer()
        AppDelegate.shared.startTimer()
    }
    
    @IBAction func styleChange(_ sender: NSPopUpButton) {
        ds.style = Style(rawValue: sender.indexOfSelectedItem)!
    }
    
    func showAlert(error: Error) {
        guard let window = self.view.window else { return }
        let alert = NSAlert(error: error)
        alert.beginSheetModal(for: window, completionHandler: nil)
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
