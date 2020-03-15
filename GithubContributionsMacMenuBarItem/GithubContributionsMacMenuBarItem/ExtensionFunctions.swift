//
//  ExtensionFunctions.swift
//  GithubContributionsMacMenuBarItem
//
//  Created by Ankith on 3/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Cocoa

extension NSMenuItem {
    public func setAction(target: AnyObject, selector: Selector) {
        self.target = target
        self.action = selector
    }
}

// Extension Function to fill a color in the contribution chart

extension NSColor {
    
    // Define colors for contribution chart
    // TODO: Add colors to Assets.xcassets
    
    static let url = NSColor(named: NSColor.Name("urlColor"))!
    static let color0 = NSColor(named: NSColor.Name("color0"))!
    static let color25 = NSColor(named: NSColor.Name("color25"))!
    static let color50 = NSColor(named: NSColor.Name("color50"))!
    static let color75 = NSColor(named: NSColor.Name("color75"))!
    static let color100 = NSColor(named: NSColor.Name("color100"))!
    static let colorDark0 = NSColor(named: NSColor.Name("colorDark0"))!
    static let colorDark25 = NSColor(named: NSColor.Name("colorDark25"))!
    static let colorDark50 = NSColor(named: NSColor.Name("colorDark50"))!
    static let colorDark75 = NSColor(named: NSColor.Name("colorDark75"))!
    static let colorDark100 = NSColor(named: NSColor.Name("colorDark100"))!
    
    
    static func fillColor(_ ContributionDepth: Int, _ style: Style, _ dark: Bool) -> NSColor {
        if style == .mono {
            let white: CGFloat = dark ? 1.0 : 0.0
            switch ContributionDepth {
            case 1: return NSColor(white: white, alpha: 0.4)
            case 2: return NSColor(white: white, alpha: 0.6)
            case 3: return NSColor(white: white, alpha: 0.8)
            case 4: return NSColor(white: white, alpha: 1.0)
            default: return NSColor(white: white, alpha: 0.2)
            }
        } else {
            switch ContributionDepth {
            case 1:  return dark ? NSColor.colorDark25 : NSColor.color25
            case 2:  return dark ? NSColor.colorDark50 : NSColor.color50
            case 3:  return dark ? NSColor.colorDark75 : NSColor.color75
            case 4:  return dark ? NSColor.colorDark100 : NSColor.color100
            default: return dark ? NSColor.colorDark0 : NSColor.color0
            }
        }
    }
}

// Extension Function to trim Strings with whitespaces

extension String {
    func trim(_ before: String, _ after: String) -> String {
        let new = self.replacingOccurrences(of: before, with: "")
        return new.replacingOccurrences(of: after, with: "")
    }
}

// Extension Function to check for Dark Mode and MacOS version

extension NSAppearance {
    var isDark: Bool {
        if self.name == .vibrantDark { return true }
        guard #available(macOS 10.14, *) else { return false }
        return self.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
    }
}
