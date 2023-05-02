//
//  FirebaseController.swift
//  Tripo
//
//  Created by lin on 26/4/2023.
//
import UIKit

import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    
    var authController: Auth
    var database: Firestore
    var usersRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    var status : Bool = false
    
    
    
    override init() {
        
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        
        super.init()
                
    }
    
    // MARK: -  database protocol methods
    
    func logUser(email: String, password: String) {
        Task {
            do {
                let authDataResult = try await authController.signIn(withEmail: email, password:password)
                currentUser = authDataResult.user
                
                listeners.invoke { (listener) in
                    if listener.listenerType == ListenerType.user ||
                        listener.listenerType == ListenerType.all {
                        listener.onUserChange(change: .update, status: true, errorMsg:nil )
                    }
                }
            }
            catch {
                print(String(describing: error))
                //fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
                listeners.invoke { (listener) in
                    if listener.listenerType == ListenerType.user ||
                        listener.listenerType == ListenerType.all {
                        listener.onUserChange(change:.update, status: false, errorMsg: String(describing: error.localizedDescription))
                    }
                }
            }
            self.setupUserListener()

        }
    }
    
    func signUser(email: String, password: String) {
        Task {
            do {
                let authDataResult = try await authController.createUser(withEmail: email, password:password)
                currentUser = authDataResult.user
                
                try await database.collection("Users").document(currentUser!.uid).setData(["username": email, "passcode": password])
                
                listeners.invoke { (listener) in
                    if listener.listenerType == ListenerType.user ||
                        listener.listenerType == ListenerType.all {
                        listener.onUserChange(change: .update, status: true, errorMsg:nil )
                    }
                }
                
            }
            catch {
                print(String(describing: error))
                //fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
                listeners.invoke { (listener) in
                    if listener.listenerType == ListenerType.user ||
                        listener.listenerType == ListenerType.all {
                        listener.onUserChange(change:.update, status: false, errorMsg: String(describing: error.localizedDescription))
                    }
                }
            }
            self.setupUserListener()

        }
    }
    
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .user || listener.listenerType == .all {
            listener.onUserChange(change: .update, status: self.status, errorMsg: nil)
        }
    }
        
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)

    }
    
    func cleanup() {
        //
    }
    
    

    
    func setupUserListener() {
        usersRef = database.collection("Users")
        usersRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard querySnapshot != nil else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            
        }
        
    }


}
