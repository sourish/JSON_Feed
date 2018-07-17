//
//  ViewController.swift
//  JSON_Feed
//
//  Created by Sourish on 07/07/18.
//  Copyright © 2018 Sourish. All rights reserved.
//

import UIKit
import Reachability

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var feedTableView: UITableView!
    var feedResponse: Feed?
    var backgroundQueue: OperationQueue?
    let reachability = Reachability()!
    fileprivate let imageDownloadsInProgress = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeViews()
        downloadFeeds()
    }

    override func viewWillAppear(_ animated: Bool) {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        APIManager.getFeedRequest(withCompletion: { response, error in
            self.feedResponse = response
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
        for indexPath in visibleIndexPaths! {
            if let feedItem: Item = feedResponse?.rows[indexPath.row] {
                if feedItem.feedImage == nil {
                    startImageDownload(imageCellData: feedItem, atIndex: indexPath.section)
                }
            }
        }
    }

    //MARK: Download Image
    
    func startImageDownload(imageCellData:Item, atIndex index:Int) {
        var imageDownloader = self.imageDownloadsInProgress[index] as? ImageDownloader
        if (imageCellData.imageHref.count > 0) {
            if imageDownloader == nil, let imageURL = URL(string: imageCellData.imageHref.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                imageDownloader = ImageDownloader(imageURL: imageURL, completionBlock: { (image:UIImage?) in
                    if image != nil {
                        imageCellData.feedImage = image
                    }
                    self.imageDownloadsInProgress.removeObject(forKey: index)
                    if self.imageDownloadsInProgress.count == 0 {
                        OperationQueue.main.addOperation {
                            self.feedTableView.reloadData()
                        }
                    }
                })
                imageDownloader?.startDownload()
                self.imageDownloadsInProgress[index] = imageDownloader
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
            cell?.titleNameLbl?.numberOfLines = 0
            cell?.titleNameLbl?.text = feedItem.title
            
            cell?.descriptionNameLbl?.numberOfLines = 0
            cell?.descriptionNameLbl?.text = feedItem.descriptionField
            
            
            cell?.selectionStyle = .none
            if feedItem.feedImage != nil {
                cell?.descriptionImageView?.image = feedItem.feedImage
                cell?.activityIndicator?.stopAnimating()
            }
            else {
                if ((feedItem.imageHref.isEmpty) || (feedItem.imageHref.count == 0)) {
                    cell?.activityIndicator?.stopAnimating()
                }
                cell?.descriptionImageView?.image = nil
                cell?.activityIndicator?.startAnimating()
            }
        }
        return cell!
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isDecelerating {
            downloadAssests()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        downloadAssests()
    }
}

