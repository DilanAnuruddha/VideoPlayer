//
//  Alert.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/11/20.
//

import Foundation
import UIKit

class Alert {
    
    private static func showAlert(on vc : UIViewController , title : String , message : String ,actions:[UIAlertAction]){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                for item in actions{
                    alert.addAction(item)
                }
                vc.present(alert , animated: true)
            }
        }
    
    public static func showDefaultAlert(on vc : UIViewController , title : String , message : String){
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            showAlert(on: vc, title: title, message: message, actions: [action])
    }
    
    
}
