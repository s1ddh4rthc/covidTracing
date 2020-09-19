//
//  DatabaseManager.swift
//  covidTracing
//
//  Created by Prem Dhoot on 9/18/20.
//  Copyright © 2020 SAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

extension DatabaseManager {
    
    public func insertUser(with user: CovidUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "firstName" : user.firstName,
            "lastName" : user.lastName,
            ], withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
        })
        
    }
    
    public func saveUserLocation(with user: CovidUser, completion: @escaping (Bool) -> Void) {
        
        self.database.child("places/" + user.safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            
            if var userLocationCollection = snapshot.value as? [[String:Double]] {
                
                let newElement = [
                    "latitude" : 36.1343,
                    "longitude" : 56.75
                ]
                
                userLocationCollection.append(newElement)
                
                self.database.child("places/" + user.safeEmail).setValue(userLocationCollection) { (error, _) in
                    
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    
                    completion(true)
                    
                }
                
                
            } else {
                
                let newCollection : [[String:Double]] = [
                    [
                        "latitude" : 96.78,
                        "longitude" : 47.69
                    ]
                ]
                
                self.database.child("places/" + user.safeEmail).setValue(newCollection) { (error, _) in
                    
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    
                    completion(true)
                    
                }
                
            }
            
        }
        
    }
    
}

struct CovidUser {
    let firstName: String
    let lastName: String
    let email: String
    
    var safeEmail: String {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
        
    }
}
