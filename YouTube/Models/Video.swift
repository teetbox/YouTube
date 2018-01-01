//
//  Video.swift
//  YouTube
//
//  Created by Matt Tian on 7/3/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import UIKit

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let uppercasedFirstCharacter = String(key.first!).uppercased()
        let selectorString = uppercasedFirstCharacter + String(key.dropFirst())
        
        let selector = NSSelectorFromString("set\(selectorString):")
        let response = self.responds(to: selector)
        
        if !response {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
}

class Video: SafeJsonObject {
    
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
    var uploadDate: Date?
    
    var channel: Channel?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel" {
            self.channel = Channel()
            self.channel?.setValuesForKeys(value as! [String: Any])
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    init(dictionary: [String: Any]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
}
