//
//  AppDelegate.swift
//  GithubContributionsMacMenuBarItem
//
//  Created by Ankith on 3/2/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    
    private let ds = DataStorage.shared
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let nc = NSWorkspace.shared.notificationCenter
    private var button: NSStatusBarButton?
    private let mainView = MainViewController()
    private var timer: Timer?
    private var preferencesViewController: NSWindowController?
    
    var window: NSWindow!
    
    
    class var shared: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setNotifications()
        setUserInterface()
        startTimer()
        if ds.username.isEmpty {
            openPreferences()
        }
    }
    
    
    func fetchData() {
        PullGitData.getContributions(username: ds.username) { [unowned self] (html, error) in
            let perDayData: [[PerDayData]]
            if let html = html {
                perDayData = ContributionDepth.parse(html: html)
            } else {
                perDayData = PerDayData.default
                if let error = error, let wc = self.preferencesViewController{
                    DispatchQueue.main.async {
                        (wc.contentViewController as! PreferencesViewController).showAlert(error: error)
                    }
                }
            }
            self.statusItem.length = 0.5 * CGFloat(5 * perDayData[0].count - 1)
            DispatchQueue.main.async {
                self.statusItem.length = 0.5 * CGFloat(5 * perDayData[0].count - 1) + 6.0
                self.mainView.update(perDayData, self.ds.color, self.ds.style)
            }
        }
    }
    
    @objc func openAbout() {
        NSApp.activate(ignoringOtherApps: true)
        let text = NSMutableParagraphStyle()
        text.alignment = .center
        let mutableAttrStr = NSMutableAttributedString()
        let key = NSApplication.AboutPanelOptionKey.credits
        NSApp.orderFrontStandardAboutPanel (options: [key: mutableAttrStr])
        var attr: [NSAttributedString.Key : Any] = [.foregroundColor : NSColor.textColor, .paragraphStyle : text]
        mutableAttrStr.append(NSAttributedString(string: "By", attributes: attr))
        let url = "https://github.com/Monkeyank/GithubContributionsMacMenuBar"
        attr = [.foregroundColor : NSColor.url, .link : url, .paragraphStyle : text]
        mutableAttrStr.append(NSAttributedString(string: url, attributes: attr))
        
    }
    
    @objc func openPreferences() {
        if preferencesViewController == nil {
            let sb = NSStoryboard(name: "Preferences", bundle: nil)
            preferencesViewController = (sb.instantiateInitialController() as! NSWindowController)
            preferencesViewController!.window?.delegate = self
        }
        NSApp.activate(ignoringOtherApps: true)
        preferencesViewController!.showWindow(nil)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: Double(ds.cycle * 60), repeats: true, block: { (_) in self.fetchData()
        })
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fire()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func receiveSleepNote() {
        stopTimer()
    }
    
    @objc func receiveWakeNote() {
        startTimer()
    }
    
    func setNotifications() {
        nc.addObserver(self, selector: #selector(receiveSleepNote),
                       name: NSWorkspace.willSleepNotification, object: nil)
        nc.addObserver(self, selector: #selector(receiveWakeNote),
                       name: NSWorkspace.didWakeNotification, object: nil)
    }
    
    func setUserInterface() {
        statusItem.menu = menu
        button = statusItem.button
        button?.addSubview(mainView)
        menu.item(withTag: 0)?.setAction(target: self, selector:#selector(openPreferences))
        menu.item(withTag: 1)?.setAction(target: self, selector:#selector(openAbout))
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        stopTimer()
        nc.removeObserver(self)
    }
    
    func updateData() {
        self.mainView.update(ds.color, ds.style)
    }
}



extension AppDelegate: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window == preferencesViewController?.window {
            preferencesViewController = nil
        }
    }
    
}
