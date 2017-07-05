//
//  NetworkService.swift
//  YouTube
//
//  Created by Matt Tian on 7/5/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    private let baseURL = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchHomeVideos(completionHandler: @escaping ([Video]) -> Void) {
        fetchVideos(from: "\(baseURL)/home.json", completionHandler: completionHandler)
    }
    
    func fetchTrendingVideos(completionHandler: @escaping ([Video]) -> Void) {
        fetchVideos(from: "\(baseURL)/trending.json", completionHandler: completionHandler)
    }
    
    func fetchSubscriptionVideos(completionHandler: @escaping ([Video]) -> Void) {
        fetchVideos(from: "\(baseURL)/subscriptions.json", completionHandler: completionHandler)
    }
    
    func fetchVideos(from url: String, completionHandler: @escaping ([Video]) -> Void) {
        let url = URL(string: url)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                
                for dictionary in json as! [[String: Any]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    video.numberOfViews = dictionary["number_of_views"] as? NSNumber
                    
                    let channelDictionary = dictionary["channel"] as! [String: Any]
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                    video.channel = channel
                    
                    videos.append(video)
                }
                
                DispatchQueue.main.async {
                    completionHandler(videos)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
}
