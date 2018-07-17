//
//  ImageDownloader.swift
//  JSON_Feed
//
//  Created by Sourish on 17/07/18.
//  Copyright © 2018 Sourish. All rights reserved.
//

import UIKit



class ImageDownloader: NSObject {
    
    private let sessionTask =  URLSession.shared
    typealias CompletionBlock = ((_ image:UIImage?) -> Void)
    var completionBlock:CompletionBlock
    var imageURL: URL
    var asyncQueue = OperationQueue()
    
    init(imageURL:URL, completionBlock:@escaping CompletionBlock) {
        self.imageURL = imageURL
        self.completionBlock = completionBlock
    }
    
    func startDownload() {
        asyncQueue.addOperation {
            let request = URLRequest(url: self.imageURL)
            let task = self.sessionTask.dataTask(with: request, completionHandler: { data, response, error in
                if (error != nil) {
                    print(error as Any)
                    self.completionBlock(nil)
                    return
                }
                OperationQueue.main.addOperation({
                    if let _ = data, let image = UIImage(data: data!) {
                        self.completionBlock(image)
                    }
                    else {
                        self.completionBlock(nil)
                    }
                })
            })
            task.resume()
        }
    }
    
    func cancelDownload() {
    }
}
