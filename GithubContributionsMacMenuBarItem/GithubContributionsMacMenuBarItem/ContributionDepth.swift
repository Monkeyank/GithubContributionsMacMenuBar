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
        var tags = html.components(separatedBy: .newlines)
        tags = tags.compactMap({ (str) -> String? in
            let res = str.trimmingCharacters(in: .whitespaces)
            return res.match("<rect class=\"day\".+(/>|></rect>)")
        })
        var perDayData = [[PerDayData]](repeating: [], count: 7)
        for i in (0 ..< tags.count) {
            let params = tags[i]
                .components(separatedBy: " ")
                .compactMap { (str) -> (key: String, value: String)? in
                    if str.contains("=") {
                        let array = str.components(separatedBy: "=")
                        return (array[0], array[1])
                    }
                    return nil
            }
            var dict = [String : String]()
            params.forEach { (param) in
                dict[param.key] = param.value.replacingOccurrences(of: "\"", with: "")
            }
            let level: Int
            switch dict["fill"] {
            case "#ebedf0": level = 0
            case "#c6e48b": level = 1
            case "#7bc96f": level = 2
            case "#239a3b": level = 3
            case "#196127": level = 4
            default: level = 0
            }
            let count = Int(dict["data-count"] ?? "0") ?? 0
            let date = dict["data-date"] ?? ""
            perDayData[i % 7].append(PerDayData(level, count, date))
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
    
    static let `default` = [[PerDayData]](repeating: [PerDayData](repeating: PerDayData(0, 0, "dummy"), count: 50), count: 7)
    
    init(_ contributiondepth: Int, _ count: Int, _ date: String) {
        self.contributiondepth = contributiondepth
        self.count = count
        self.date = date
    }
}
