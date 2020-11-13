//
//  Extensions.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/11/20.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

extension UIView{
    
    func addSubViews(_ views:UIView...) {
        views.forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
}

extension UIViewController{
    func addLoaderToView(view:UIView,loader:UIActivityIndicatorView,loaderBackground:UIView) {
    DispatchQueue.main.async {
        view.addSubViews(loaderBackground)
        loaderBackground.translatesAutoresizingMaskIntoConstraints = false
        loaderBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loaderBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let width = UIDevice.current.userInterfaceIdiom == .pad ? 0.1 : 0.3
        loaderBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: CGFloat(width)).isActive = true
        loaderBackground.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: CGFloat(width)).isActive = true

        loaderBackground.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        loader.isHidden = false
        loader.startAnimating()
    }
}

func removeLoader(loader:UIActivityIndicatorView,loaderBackground:UIView)  {
    DispatchQueue.main.async {
        loader.stopAnimating()
        loader.isHidden = true
        loaderBackground.removeFromSuperview()
    }
}
}

extension String {
    var isValidEmail: Bool {
          let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
          return testEmail.evaluate(with: self)
       }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
