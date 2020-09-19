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
