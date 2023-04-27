//
//  File.swift
//  Tripo
//
//  Created by lin on 26/4/2023.
//

import Foundation
import Firebase

enum DatabaseChange{
    case add
    case remove
    case update
}

enum ListenerType {

    case all
    case user
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onUserChange(change: DatabaseChange, status: Bool, errorMsg:String?)
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    //week 6
    func logUser(email:String, password: String)
    func signUser(email:String, password: String)
    
}

