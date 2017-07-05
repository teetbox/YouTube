//
//  SubscriptionCell.swift
//  YouTube
//
//  Created by Matt Tian on 7/5/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    
    override func fetchVideos() {
        NetworkService.shared.fetchSubscriptionVideos { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
