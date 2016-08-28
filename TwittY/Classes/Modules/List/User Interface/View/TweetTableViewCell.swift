//
//  TweetTableViewCell.swift
//  TwittY
//
//  Created by Aleksei Kolchanov on 28/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    let defaultHorizontalDistance: CGFloat = 12.0
    let imageViewSize: CGFloat = 51.0
    let imageViewCornerRadius: CGFloat = 5.0
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var userNameLabelLeadingConstraint: NSLayoutConstraint!
    
    weak var avatarImageView: UIImageView?
    
    var showAvatar: Bool = true {
        didSet {
            if (showAvatar) {
                addAvatarImageView()
            }else{
                removeAvatarImageView()
            }
        }
    }
    
    private func addAvatarImageView() {
        if avatarImageView != nil {
            return
        }
        
        let imageView = UIImageView(frame: CGRectZero)
        imageView.backgroundColor = TwittYxStyleKit.lightGray
        imageView.layer.cornerRadius = imageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        avatarImageView = imageView
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(defaultHorizontalDistance)-[imageView(\(imageViewSize))]-\(defaultHorizontalDistance)-[userNameLabel]", options: [], metrics: nil, views: ["imageView" : imageView, "userNameLabel" : userNameLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[imageView(\(imageViewSize))]-(>=\(defaultHorizontalDistance))-|", options: [], metrics: nil, views: ["imageView" : imageView]));
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: userNameLabel, attribute: .Top, multiplier: 1.0, constant: 0.0))
        
        userNameLabelLeadingConstraint.constant = 2.0 * defaultHorizontalDistance + imageViewSize
        
    }
    
    private func removeAvatarImageView() {
        if let actualAvatarImageView = avatarImageView {
            actualAvatarImageView.removeFromSuperview()
        }
        
        userNameLabelLeadingConstraint.constant = defaultHorizontalDistance
        
    }
    
}
