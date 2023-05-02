//
//  File.swift
//  Tripo
//
//  Created by Huiying Lin on 2/5/2023.
//

import UIKit

class TranslatedText: NSObject, Decodable {
    
    var text: [[Translation_inner]]?
    
    
    private enum CodingKeys: String, CodingKey {
        case text = "translateResult"
    }
    
    
}


class Translation_inner: NSObject, Decodable {
    //{"type":"EN2ZH_CN","errorCode":0,"elapsedTime":0,"translateResult":[[{"src":"hello","tgt":"你好"}]]}
    var text : String
    var translated : String
    
    private enum TransKeys: String, CodingKey {
        case src
        case tgt
    }
    
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: TransKeys.self)

        text = try rootContainer.decode(String.self, forKey: .src)
        translated = try rootContainer.decode(String.self, forKey: .tgt)
        
    }
}


