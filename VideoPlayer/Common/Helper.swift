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

//MARK:Firebase Anaytics Keys
enum FirebaseAnalyticKey{
    static let LOGIN_BUTTON_PRESS = "login_button_press"
    static let SIGNUP_LINK_CLICK = "signup_link_click"
    static let SIGNUP_BUTTON_PRESS = "signup_button_press"
    static let LOGOUT_BUTTON_PRESS = "logout_button_press"
    static let START_FULL_SCREEN = "start_full_screen"
    static let END_FULL_SCREEN = "end_full_screen"
}

