//
//  Components.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/12/20.
//

import Foundation
import UIKit

class Components {
    
    static func createPaddingTextField(type:UITextContentType = .name,placeHolder:String)->PaddingTextField{
        let txt = PaddingTextField()
        txt.placeholder = placeHolder
        txt.backgroundColor = .white
        txt.layer.cornerRadius = 5
        txt.textContentType = type
        txt.isSecureTextEntry = type == .password
        txt.clipsToBounds = true
        return txt
    }


    static func getLoaderViewSet()->(UIActivityIndicatorView,UIView) {
        let loader = UIActivityIndicatorView()
        loader.style = UIActivityIndicatorView.Style.large
        loader.color = .systemBackground

            //loader background
        let view = UIView()
        view.backgroundColor = UIColor(named: "systemColor_inverse")?.withAlphaComponent(0.8)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10

        return (loader,view)
    }
}
