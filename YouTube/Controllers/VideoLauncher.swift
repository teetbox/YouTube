//
//  VideoLauncher.swift
//  YouTube
//
//  Created by Matt Tian on 7/6/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import UIKit

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let videoView = UIView(frame: keyWindow.frame)
            videoView.backgroundColor = UIColor.white
            videoView.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            
            videoView.addSubview(videoPlayerView)
            keyWindow.addSubview(videoView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                videoView.frame = keyWindow.frame
                
            }, completion: { (_) in
                
                UIApplication.shared.isStatusBarHidden = true
                
            })
        }
    }
    
}
