//
//  APIManager.swift
//  JSON_Feed
//
//  Created by Sourish on 07/07/18.
//  Copyright © 2018 Sourish. All rights reserved.
//

import Foundation

class APIManager {
    class func getFeedRequest(withCompletion completion: @escaping (_ feedResponse: Feed?, _ error: Error?) -> Void) {
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let request = URLRequest(url: url!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { data, response, error -> Void in
            if error != nil {
                completion(nil, error)
            }
            else {
                var iso = ""
                if let aData = data {
                    iso = String(data: aData, encoding: .isoLatin1)!
                }
                let dutf8: Data? = iso.data(using: .utf8)
                var serializedResponse: Any? = nil
                if let aDutf8 = dutf8 {
                    serializedResponse = try? JSONSerialization.jsonObject(with: aDutf8, options: .mutableContainers)
                }
                print(serializedResponse)
                let feedResponse: Feed? = Feed(dictionary: serializedResponse as! [AnyHashable : Any])
                completion(feedResponse, nil)
            }
        }
        
        task.resume()
    }
    

}
