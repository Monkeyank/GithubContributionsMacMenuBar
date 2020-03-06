//
//  DataIndexer.swift
//  GithubContributionsMacMenuBarItem
//
//  Created by Ankith on 3/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation


class ContributionDepth {
    static func parse(html: String) -> [[PerDayData]] {
        var component = html.components(separatedBy: .newlines)
        component = component.compactMap( { (str) -> String? in
            let res = str.trimmingCharacters(in: .whitespaces)
            if res.hasPrefix("<rect"){
                return res
            }
            return nil
        })
        //
        var perDayData: [[PerDayData]] = [[], [], [], [], [], [], []]
        component.forEach { (str) in
            let parameter = str.components(separatedBy: " ")
            let y = Int(parameter[5].trim("y=\"", "\""))! / 15
            let contributiondepth: Int
            
            // Storing contribution with color of the chart
            
            switch parameter[6].trim("fill=\"", "\"") {
            case "#ebedf0": contributiondepth = 0
            case "#c6e48b": contributiondepth = 1
            case "#7bc96f": contributiondepth = 2
            case "#239a3b": contributiondepth = 3
            case "#196127": contributiondepth = 4
            default: contributiondepth = 0
            }
            perDayData[y].append(PerDayData(contributiondepth: contributiondepth, count:Int(parameter[7].trim("data-count=\"", "\""))!,
                date: parameter[8].trim("data-date=\"", "\"/>")))
        }
        return perDayData
    }
}

struct PerDayData {
    let contributiondepth: Int
    let count: Int
    let date: String
    
    // Contribution depth tagged with # of contributions and date
    
    var description: String{
        return "contributiondepth: \(contributiondepth) count: \(count) date: \(date)"
    }
    
    static let `default` = [[PerDayData]] (repeating: [PerDayData] (repeating: PerDayData(contributiondepth: 0, count: 0, date: "date"), count: 50), count: 7)
}
