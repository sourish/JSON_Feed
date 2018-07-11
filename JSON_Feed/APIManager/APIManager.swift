//
//  APIManager.swift
//  JSON_Feed
//
//  Created by Sourish on 07/07/18.
//  Copyright © 2018 Sourish. All rights reserved.
//

import Foundation
import UIKit

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
                let feedResponse: Feed? = Feed(dictionary: serializedResponse as! [AnyHashable : Any])
                completion(feedResponse, nil)
            }
        }
        
        task.resume()
    }
    
    class func downLoadImage(item: Item?, withCallBack completion: @escaping (Item?, Error?) -> Void) {
        if item?.imageHref != nil {
            var request: URLRequest? = nil
            if let aHref = URL(string: (item?.imageHref)!) {
                request = URLRequest(url: aHref)
            }
            if let aRequest = request {
                NSURLConnection.sendAsynchronousRequest(aRequest, queue: OperationQueue.main, completionHandler: { response, data, error in
                    if error != nil {
                        completion(nil, error)
                    } else {
                        var downloadedImage: UIImage?
                        if let aData = data {
                            downloadedImage = UIImage(data: aData)
                        }
                        item?.feedImage = downloadedImage
                        completion(item!, nil)
                    }
                })
            }
        }
    }

}
