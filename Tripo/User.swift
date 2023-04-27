//
//  User.swift
//  Tripo
//
//  Created by lin on 26/4/2023.
//

import UIKit
import FirebaseFirestoreSwift

class User: NSObject, Codable {
    @DocumentID var id: String?
    var username: String?
    var passcode: String?
    // ADD more attrubitus here for future
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case passcode
        // ADD more attrubitus here for future
        }

}
