//
//  ViewController.swift
//  JSON_Feed
//
//  Created by Sourish on 07/07/18.
//  Copyright © 2018 Sourish. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var feedTableView: UITableView!
    var feedResponse: Feed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeViews()
        downloadFeeds()
    }

    func intializeViews() {
        feedTableView = UITableView(frame: CGRect.zero, style: .plain)
        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableView.estimatedRowHeight = 60
        feedTableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(feedTableView)
        feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        feedTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

    }
    
    func downloadFeeds() {
        print ("download")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        APIManager.getFeedRequest(withCompletion: { response, error in
            self.feedResponse = response
            print("response \(self.feedResponse)")
            OperationQueue.main.addOperation({
                if let _ = self.feedResponse?.title {
                    self.title = self.feedResponse?.title
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.feedTableView.reloadData()
            })
        })

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.feedResponse?.rows {
            return (self.feedResponse?.rows.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell;
    }
}

