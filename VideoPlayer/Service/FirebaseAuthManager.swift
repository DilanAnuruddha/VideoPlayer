//
//  FirebaseAuthManager.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/12/20.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    func createUser(email: String, password: String, completionHandler: @escaping (_ success: Bool) -> Void) {
           Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
               if let user = authResult?.user {
                print(user)
                completionHandler(true)
               } else {
                print(error)
                Helper.errorMsg = error.debugDescription
                completionHandler(false)
               }
           }
    }
    
    func signIn(email: String, pass: String, completionHandler: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionHandler(false)
            } else {
                Helper.errorMsg = error.debugDescription
                completionHandler(true)
            }
        }
    }
}
