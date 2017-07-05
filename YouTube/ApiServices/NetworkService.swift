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
            if let error = error {
                print(error)
            }
            
            do {
                if let jsonData = data, let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String: Any]] {
                    
                    let videos = jsonDict.map { Video(dictionary: $0) }
                    
                    DispatchQueue.main.async {
                        completionHandler(videos)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
}
