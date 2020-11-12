//
//  PlayerViewController.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/11/20.
//

import UIKit
import AVFoundation
import AVKit

class PlayerViewController: UIViewController {
    var playerViewController=AVPlayerViewController()
    var playerView:AVPlayer = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "My Player"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target:self , action: #selector(didClickedBtnLogout))
        setupView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setupVideoView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if (self.isMovingFromParent) {
              UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    
    //MARK: Setup UI
    func setupView()  {
        view.addSubViews(playerViewController.view)
        NSLayoutConstraint.activate([
            playerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        playerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}


//MARK: Functions
extension PlayerViewController{
    
    @objc func canRotate() -> Void {}//allow screen rotation when device rotate
    
    @objc func didClickedBtnLogout(){
        let alert = UIAlertController(title: "Confirm", message: "Are you sure want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    fileprivate func setupVideoView(){
        playerView = AVPlayer(url: URL(string: VideoURL.url)!)
        playerView.actionAtItemEnd = .pause
        
        playerViewController.player = playerView
        playerViewController.player?.playImmediately(atRate: 1.0)
        playerViewController.player?.play()
    }
    
}
