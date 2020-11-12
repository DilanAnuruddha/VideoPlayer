//
//  Helper.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/12/20.
//

import Foundation

class Helper{
    
    static var successMsg:String = ""
    static var errorMsg:String = ""
    
    static func validateLogin(uName:String,uPassword:String,completionHandler:@escaping(Result<Bool,LoginError>)->Void){
        if uName.isEmpty{
            completionHandler(.failure(.emptyMail))
        }else if !uName.isValidEmail{
            completionHandler(.failure(.invalidMail))
        }else if uPassword.isEmpty {
            completionHandler(.failure(.emptyPassword))
        }else{
            completionHandler(.success(true))
        }
    }
    
    static func validateSignup(uName:String,uPassword:String,uConfirm:String,completionHandler:@escaping(Result<Bool,LoginError>)->Void){
        if uName.isEmpty{
            completionHandler(.failure(.emptyMail))
        }else if !uName.isValidEmail{
            completionHandler(.failure(.invalidMail))
        }else if uPassword.isEmpty {
            completionHandler(.failure(.emptyPassword))
        }else if uConfirm.isEmpty || uConfirm != uPassword{
            completionHandler(.failure(.mismatchPassword))
        } else{
            completionHandler(.success(true))
        }
    }
}

//MARK: Login error
enum LoginError:Error {
    case emptyMail
    case invalidMail
    case emptyPassword
    case mismatchPassword
}

