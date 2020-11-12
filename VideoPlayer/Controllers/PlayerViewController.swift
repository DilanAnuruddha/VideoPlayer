//
//  PlayerViewController.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/11/20.
//

import UIKit
import AVFoundation
import AVKit
import FirebaseAnalytics

class PlayerViewController: UIViewController {
    var avPlayerVC=AVPlayerViewController()
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
        view.addSubViews(avPlayerVC.view)
        NSLayoutConstraint.activate([
            avPlayerVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avPlayerVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            avPlayerVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avPlayerVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        avPlayerVC.delegate = self
        avPlayerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

//MARK: AVPlayerViewController Delegates
extension PlayerViewController:AVPlayerViewControllerDelegate{
    func playerViewController(_ playerViewController: AVPlayerViewController, willBeginFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        Analytics.logEvent(FirebaseAnalyticKey.START_FULL_SCREEN, parameters: nil)
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        Analytics.logEvent(FirebaseAnalyticKey.END_FULL_SCREEN, parameters: nil)
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
        
        avPlayerVC.player = playerView
        avPlayerVC.player?.playImmediately(atRate: 1.0)
        avPlayerVC.player?.play()
    }
    
}
