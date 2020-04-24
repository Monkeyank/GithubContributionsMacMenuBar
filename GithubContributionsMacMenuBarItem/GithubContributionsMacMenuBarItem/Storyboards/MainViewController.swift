//
//  MainViewController.swift
//  GithubContributionsMacMenuBarItem
//
//  Created by Ankith on 3/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

enum Color: Int {
    case mono = 0
    case green = 1
}

enum Style: Int {
    case block = 0
    case dot = 1
}

class MainViewController: NSView {
    
    private var ao: NSKeyValueObservation?
    var perDayData = [[PerDayData]]()
    var color: Color = .mono
    var style: Style = .block
    
    // Intializing view
    
    init() {
        super.init(frame: NSRect(x: 0, y: 2, width: 10, height: 18))
        ao = self.observe(\.effectiveAppearance, changeHandler: { [weak self] (_, _) in
            self?.needsDisplay = true
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        ao?.invalidate()
    }
    
    // Adding data to view
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if perDayData.isEmpty { return }
        let dark = self.effectiveAppearance.isDark
        for i in (0 ..< 7) {
            for j in (0 ..< perDayData[i].count) {
                NSColor.fillColor(perDayData[i][j].contributiondepth, color, dark).setFill()
                let rect = NSRect(x: 2.5 * CGFloat(j),
                                  y: 15.5 - 2.5 * CGFloat(i),
                                  width: 2.0, height: 2.0)
                let path = NSBezierPath(rect: rect)
                path.fill()
            }
        }
    }
    
    // Updating view with new data
    
    func update(_ perDayData: [[PerDayData]], _ color: Color, _ style: Style) {
        self.perDayData = perDayData
        self.color = color
        self.style = style
        let width = 0.5 * CGFloat(5 * perDayData[0].count - 1)
        self.frame.size = CGSize(width: width, height: 18.0)
        self.needsDisplay = true
    }
    
    func update(_ color: Color, _ style: Style) {
        self.color = color
        self.style = style
        self.needsDisplay = true
    }
    
}
