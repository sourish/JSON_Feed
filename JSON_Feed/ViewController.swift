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
    var backgroundQueue: OperationQueue?
    
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
        feedTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "FeedCell")
        feedTableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(feedTableView)
        feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        feedTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        self.backgroundQueue = OperationQueue()
    }
    
    func downloadFeeds() {
        print ("download")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        APIManager.getFeedRequest(withCompletion: { response, error in
            self.feedResponse = response
            print("response \(String(describing: self.feedResponse))")
            OperationQueue.main.addOperation({
                if let _ = self.feedResponse?.title {
                    self.title = self.feedResponse?.title
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.feedTableView.reloadData()
                self.downloadAssests()
            })
        })

    }

    func downloadAssests() {
        let visibleIndexPaths = feedTableView.indexPathsForVisibleRows
        for indexPath: IndexPath? in visibleIndexPaths ?? [IndexPath?]() {
            if let feedItem: Item = feedResponse?.rows[indexPath!.row] {
                if feedItem.feedImage == nil {
                    self.backgroundQueue?.addOperation({
                        APIManager.downLoadImage(item: feedItem, withCallBack: { (responseFeedItem:Item?, error:Error?) in
                            OperationQueue.main.addOperation({
                                var cell: CustomTableViewCell? = nil
                                if responseFeedItem != nil {
                                    let rowIndex = self.getItemIndex(from: (self.feedResponse?.rows)!, itemObj: feedItem)
                                    cell = self.feedTableView.cellForRow(at: IndexPath(row: rowIndex!, section: 0)) as? CustomTableViewCell
                                    if cell != nil {
                                        cell?.descriptionImageView?.image = feedItem.feedImage
                                        cell?.removeLoaderView()
                                    }
                                }
                            })
                        })
                    })
                }
            }
        }
    }

    func getItemIndex(from: [Item], itemObj: Item) -> Int? {
        return from.index(where: { $0 === itemObj })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.feedResponse?.rows {
            return (self.feedResponse?.rows.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FeedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CustomTableViewCell
        cell?.isHidden = false
        if let feedItem = self.feedResponse?.rows[indexPath.row] {
            print(feedItem.title)
            cell?.titleNameLbl?.text = feedItem.title
            cell?.descriptionNameLbl?.text = feedItem.descriptionField
            cell?.titleNameLbl?.numberOfLines = 0
            cell?.descriptionNameLbl?.numberOfLines = 0
            cell?.selectionStyle = .none
            if feedItem.feedImage != nil {
                
            }
        }
        return cell!
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        downloadAssests()
    }
}

