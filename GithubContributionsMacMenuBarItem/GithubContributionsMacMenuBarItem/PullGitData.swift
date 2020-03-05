//
//  PullGitData.swift
//  GithubContributionsMacMenuBarItem
//
//  Created by Ankith on 3/4/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation

class PullGitData {
    //Pull data from Github API for contributions
    
    static func getContributions(username: String, callback: @escaping
        (_ response:
        String?, _ error: Error?) -> ()) {
        guard let url = URL(string:
            "https://github.com/users/\(username)/contributions")
            else {
                return
        }
        let session = URLSession(configuration:
            URLSessionConfiguration.default)
        let task = session.dataTask(with: url) { (data, response, error) in switch (data, response, error) {
        case (_, _, .some):
            let Response = response as! HTTPURLResponse
            let statusCode = Response.statusCode
            if statusCode == 200 {
                let text = String(data: data!, encoding: String.Encoding.utf8)!
                callback(text, nil)
            } else {
                if var status = Response.allHeaderFields["Status"]
                    as? String {
                    if statusCode == 404 {
                        status = "notFound"
                    }
                    let info: [String : Any] = [NSLocalizedDescriptionKey : status]
                    let error = NSError(domain: "Git Contributions", code: statusCode, userInfo: info)
                    callback (nil, error)
                    
                } else {
                    callback(nil, nil)
                }
            }
        default: break
            
            }
            
        }
        task.resume()
        
    }
}
