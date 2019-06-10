//
//  CollectionViewCell.swift
//  INFS3202
//
//  Created by Adam Dorogi-Kaposi on 21/5/18.
//  Copyright © 2018 Adam Dorogi-Kaposi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var backgroundImageView = UIImageView()
    var title = String()
    var releaseDate = String()
    let likeButton = UIButton()
    var toggleLike: ((CollectionViewCell) -> ())?
    var liked: Bool!
    var likes = Int()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set corner radius.
        layer.cornerRadius = frame.width / 32
        layer.masksToBounds = true
        
        // Set border.
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(white: 1.0, alpha: 0.16).cgColor
        
        // Set background image
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundView = backgroundImageView
        
        // Set title view
        let blur = UIBlurEffect(style: .dark)
        let titleView = UIVisualEffectView(effect: blur)
        titleView.frame.size = CGSize(width: frame.width, height: 4 * layer.cornerRadius)
        titleView.frame.origin = CGPoint(x: 0, y: frame.height - titleView.frame.height)
        contentView.addSubview(titleView)
        
        // String to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormatter.date(from: releaseDate)
        
        // Date to string
        dateFormatter.dateFormat = "yyyy"
        let dateString = dateFormatter.string(from: date!)
        
        // Set like button
        likeButton.frame.size = CGSize(width: layer.cornerRadius * 2, height: layer.cornerRadius * 2)
        likeButton.frame.origin = CGPoint(x: titleView.frame.width - likeButton.frame.width - layer.cornerRadius, y: (titleView.frame.height - likeButton.frame.height) / 2)
        likeButton.tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        if liked {
            likeButton.setImage(UIImage(named: "heartIconSelected"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "heartIcon"), for: .normal)
        }
        titleView.contentView.addSubview(likeButton)
        
        // Likes label
        let likesLabel = UILabel()
        likesLabel.text = "\(likes)"
        likesLabel.font = .systemFont(ofSize: 16, weight: .bold)
        likesLabel.sizeToFit()
        likesLabel.frame.origin = CGPoint(x: likeButton.frame.origin.x - likesLabel.frame.width - layer.cornerRadius, y: (titleView.frame.height - likesLabel.frame.height) / 2)
        likesLabel.textColor = UIColor(white: 1.0, alpha: 0.5)
        
        titleView.contentView.addSubview(likesLabel)
        
        // Set title label
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: layer.cornerRadius, y: 0, width: likesLabel.frame.origin.x - 2 * layer.cornerRadius, height: titleView.frame.height)
        titleLabel.text = "\(title) (\(dateString))"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        titleView.contentView.addSubview(titleLabel)
    }
    
    @objc func likeButtonTapped() {
        self.toggleLike!(self)
    }
}
