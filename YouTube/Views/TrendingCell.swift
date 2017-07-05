//
//  TrendingCell.swift
//  YouTube
//
//  Created by Matt Tian on 7/5/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideos() {
        NetworkService.shared.fetchTrendingVideos { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
