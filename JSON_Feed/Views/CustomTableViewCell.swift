//
//  CustomTableViewCell.swift
//  JSON_Feed
//
//  Created by Sourish on 07/07/18.
//  Copyright © 2018 Sourish. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var titleNameLbl: UILabel? = UILabel()
    var descriptionNameLbl: UILabel? = UILabel()
    var descriptionImageView: UIImageView? = UIImageView()
    var activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        descriptionNameLbl?.textColor = .lightGray
        descriptionImageView?.layer.cornerRadius = 30
        descriptionImageView?.clipsToBounds = true
        descriptionImageView?.layer.masksToBounds = true
        descriptionImageView?.backgroundColor = UIColor.lightGray

        activityIndicator?.hidesWhenStopped = true
        contentView.addSubview(titleNameLbl!)
        contentView.addSubview(descriptionNameLbl!)
        contentView.addSubview(descriptionImageView!)
        descriptionImageView?.addSubview(activityIndicator!)
        
        titleNameLbl?.translatesAutoresizingMaskIntoConstraints = false
        descriptionNameLbl?.translatesAutoresizingMaskIntoConstraints = false
        descriptionImageView?.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionImageView?.contentMode = .scaleToFill
        descriptionImageView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        descriptionImageView?.widthAnchor.constraint(equalToConstant: 60).isActive = true
        descriptionImageView?.heightAnchor.constraint(equalToConstant: 60).isActive = true
        descriptionImageView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        
        titleNameLbl?.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        titleNameLbl?.leadingAnchor.constraint(equalTo: descriptionImageView!.trailingAnchor, constant: 10).isActive = true
        titleNameLbl?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        titleNameLbl?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        
        descriptionNameLbl?.topAnchor.constraint(equalTo: titleNameLbl!.bottomAnchor, constant: 5).isActive = true
        descriptionNameLbl?.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        descriptionNameLbl?.leadingAnchor.constraint(equalTo: titleNameLbl!.leadingAnchor, constant: 0).isActive = true
        descriptionNameLbl?.trailingAnchor.constraint(equalTo: titleNameLbl!.trailingAnchor, constant: 0).isActive = true
        descriptionNameLbl?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        activityIndicator?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator?.centerYAnchor.constraint(equalTo: (descriptionImageView?.centerYAnchor)!, constant: 0).isActive = true
        activityIndicator?.centerXAnchor.constraint(equalTo: (descriptionImageView?.centerXAnchor)!, constant: 0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoaderView() {
        activityIndicator?.startAnimating()
    }
    
    func removeLoaderView() {
        activityIndicator?.stopAnimating()
    }
}
