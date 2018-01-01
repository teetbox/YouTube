//
//  VedioPlayerView.swift
//  YouTube
//
//  Created by Matt Tian on 7/6/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let playerObserverKeyPath = "currentItem.loadedTimeRanges"
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    var isPlaying = false
    
    let trackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    let lengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        return label
    }()
    
    lazy var videoSlide: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor.red
        slider.maximumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.isHidden = true
        slider.addTarget(self, action: #selector(handleSlideChange), for: .valueChanged)
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        setupGradientLayer()
        
        addSubview(controlsContainerView)
        controlsContainerView.frame = self.frame
        
        controlsContainerView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(trackLabel)
        trackLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        trackLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        trackLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        trackLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        controlsContainerView.addSubview(lengthLabel)
        lengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        lengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        lengthLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        controlsContainerView.addSubview(videoSlide)
        videoSlide.leftAnchor.constraint(equalTo: trackLabel.rightAnchor, constant: -8).isActive = true
        videoSlide.rightAnchor.constraint(equalTo: lengthLabel.leftAnchor, constant: 8).isActive = true
        videoSlide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlide.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    var player: AVPlayer?
    
    private func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
        }
        
        backgroundColor = UIColor.black
        
        player?.addObserver(self, forKeyPath: playerObserverKeyPath, options: .new, context: nil)
        
        let interval = CMTime(value: 1, timescale: 2)
        
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { (progressTime) in
            let seconds = progressTime.seconds
            let secondsText = String(format: "%02d", Int(seconds) % 60)
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            self.trackLabel.text = "\(minutesText):\(secondsText)"
            
            if let duration = self.player?.currentItem?.duration {
                let totalSeconds = duration.seconds
                self.videoSlide.value = Float(seconds / totalSeconds)
            }
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor]
        gradientLayer.locations = [0.7, 1.1]
        
        layer.addSublayer(gradientLayer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == playerObserverKeyPath {
            activityIndicator.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let totalSeconds = duration.seconds
                let secondsText = String(format: "%02d", Int(totalSeconds) % 60)
                let minutesText = String(format: "%02d", Int(totalSeconds) / 60)
                lengthLabel.text = "\(minutesText):\(secondsText)"
                lengthLabel.isHidden = false
                trackLabel.isHidden = false
                videoSlide.isHidden = false
            }
        }
    }
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        
        isPlaying = !isPlaying
        
        let image = isPlaying ? UIImage(named: "pause") : UIImage(named: "play")
        pausePlayButton.setImage(image, for: .normal)
    }
    
    @objc func handleSlideChange() {
        if let duration = player?.currentItem?.duration {
            let targetSeconds = duration.seconds * Double(videoSlide.value)
            let seekTime = CMTime(seconds: targetSeconds, preferredTimescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (_) in
                // do something later...
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
