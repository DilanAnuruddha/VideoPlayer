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
    var playerLayer:AVPlayerLayer?
    var player:AVPlayer = AVPlayer()
    var timeObserver: Any?
    var timer: Timer?
    var isFullScreen:Bool = false

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
        resetTimer()
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleControls))
        view.addGestureRecognizer(viewTapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
//        if (self.isMovingFromParent) {
//              UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
//        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
        }) { (context) in
            self.playerLayer?.frame.size = size
            self.playerView.frame.size = size
        }

    }
    
    //MARK: Components
    let playerView:UIView = {
        let uv = UIView()
        uv.backgroundColor = .black
        return uv
    }()
    
    let btnPlayPause:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "pause.fill",withConfiguration: SFSymbolConfig.largeConfig)?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
        return btn
    }()
    
    let timeLine:UISlider = {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = .red
        return slider
    }()
    
    let lblTime:UILabel = {
        let lbl = UILabel()
        lbl.text = "--:--"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return lbl
    }()
    
    let btnForward:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "goforward.15",withConfiguration: SFSymbolConfig.largeConfig)?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
        return btn
    }()
    
    let btnBackward:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "gobackward.15",withConfiguration: SFSymbolConfig.largeConfig)?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
        return btn
    }()
    
    let btnFullScreen:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "rectangle",withConfiguration: SFSymbolConfig.largeConfig)?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
        return btn
    }()
    
    
    //MARK: Setup UI
    func setupView()  {
        view.addSubViews(playerView,btnPlayPause,lblTime,timeLine,btnForward,btnBackward,btnFullScreen)
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            btnPlayPause.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnPlayPause.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnPlayPause.widthAnchor.constraint(equalToConstant: 50),
            btnPlayPause.heightAnchor.constraint(equalToConstant: 50),
            
            lblTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lblTime.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            lblTime.widthAnchor.constraint(equalToConstant: 60),
            
            timeLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeLine.trailingAnchor.constraint(equalTo: lblTime.leadingAnchor, constant: -8),
            timeLine.centerYAnchor.constraint(equalTo: lblTime.centerYAnchor),
            
            btnBackward.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -(view.frame.width/4)),
            btnBackward.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnBackward.widthAnchor.constraint(equalToConstant: 50),
            btnBackward.heightAnchor.constraint(equalToConstant: 50),
            
            btnForward.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: (view.frame.width/4)),
            btnForward.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnForward.widthAnchor.constraint(equalToConstant: 50),
            btnForward.heightAnchor.constraint(equalToConstant: 50),
            
            btnFullScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            btnFullScreen.bottomAnchor.constraint(equalTo: timeLine.topAnchor,constant: -8),
            btnFullScreen.widthAnchor.constraint(equalToConstant: 30),
            btnFullScreen.heightAnchor.constraint(equalToConstant: 20),
        ])
        view.sendSubviewToBack(playerView)
        btnPlayPause.addTarget(self, action: #selector(didClickedPlayPause), for: .touchUpInside)
        timeLine.addTarget(self, action: #selector(didTimeLineValueChanged(_:)), for: .valueChanged)
        btnBackward.addTarget(self, action: #selector(didClickedBtnBacward), for: .touchUpInside)
        btnForward.addTarget(self, action: #selector(didClickedBtnForward), for: .touchUpInside)
        btnFullScreen.addTarget(self, action: #selector(didClickedBtnFullScreen), for: .touchUpInside)

    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
}


//MARK: Functions
extension PlayerViewController{
    
    @objc func didClickedBtnLogout(){
        let alert = UIAlertController(title: "Confirm", message: "Are you sure want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    fileprivate func setupVideoView(){
        if CheckConnection.isConnected() {
            /* Video play using remote URL*/
//            guard let url = URL(string: VideoURL.url) else {
//                    return
//            }
            
            /* Video play using local URL*/
            guard let path = Bundle.main.path(forResource: "BigBuckBunny", ofType:"mp4") else {
                debugPrint("BigBuckBunny.mp4 not found")
                return
            }
            
            
            player = AVPlayer(url: URL(fileURLWithPath: path))
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = playerView.bounds;
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            playerLayer?.masksToBounds = true
            playerView.layer.addSublayer(playerLayer!)
            player.play()
            
            let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsedTime in
                self.updateTimeLine()
            })
        }else{
            Alert.showNoConnectionAlert(on: self)
        }
        
    }
    
    func updateTimeLine() {
        let currentTimeInSeconds = CMTimeGetSeconds(player.currentTime())
        timeLine.value = Float(currentTimeInSeconds)
        if let currentItem = player.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let currentTime = currentItem.currentTime()
            timeLine.value = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration))
            
            // Update time label
            let totalTimeInSeconds = CMTimeGetSeconds(duration)
            let remainingTimeInSeconds = totalTimeInSeconds - currentTimeInSeconds

            let mins = remainingTimeInSeconds / 60
            let secs = remainingTimeInSeconds.truncatingRemainder(dividingBy: 60)
            let timeformatter = NumberFormatter()
            timeformatter.minimumIntegerDigits = 2
            timeformatter.minimumFractionDigits = 0
            timeformatter.roundingMode = .down
            guard let minutes = timeformatter.string(from: NSNumber(value: mins)), let seconds = timeformatter.string(from: NSNumber(value: secs)) else {
                return
            }
            lblTime.text = "\(minutes):\(seconds)"
        }
    }
    
    @objc func didTimeLineValueChanged(_ sender:UISlider){
        let value = Float64(timeLine.value) * CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 10))
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        player.seek(to: seekTime )
        Analytics.logEvent(FirebaseAnalyticKey.TIMELINE_VALUE_CHANGE, parameters: ["current_time":value])
    }
    
    @objc func didClickedPlayPause(){
        if !player.isPlaying {
            player.play()
            btnPlayPause.setImage(UIImage(systemName: "pause.fill",withConfiguration: SFSymbolConfig.largeConfig)?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
        } else {
            btnPlayPause.setImage(UIImage(systemName: "play.fill",withConfiguration: SFSymbolConfig.largeConfig)?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
            player.pause()
        }
        Analytics.logEvent(FirebaseAnalyticKey.VIDEO_PLAY_PAUSE, parameters: ["new_satatus":player.isPlaying ? "pause" : "play"])
    }
    
    @objc func didClickedBtnBacward(){
        let newTime =  CMTimeGetSeconds(player.currentTime()).advanced(by: -15)
        let seekTime = CMTime(value: CMTimeValue(newTime), timescale: 1)
        player.seek(to: seekTime)
        Analytics.logEvent(FirebaseAnalyticKey.VIDEO_GO_BACKWARD, parameters: ["current_time":player.currentTime()])
    }
    
    @objc func didClickedBtnForward(){
        let newTime =  CMTimeGetSeconds(player.currentTime()).advanced(by: 15)
        let seekTime = CMTime(value: CMTimeValue(newTime), timescale: 1)
        player.seek(to: seekTime)
        Analytics.logEvent(FirebaseAnalyticKey.VIDEO_GO_FORWARD, parameters: ["current_time":player.currentTime()])
    }
    
    @objc func didClickedBtnFullScreen(){
        //change player layer video gravity.
        if !isFullScreen {
            isFullScreen = true
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            btnFullScreen.setImage(UIImage(systemName: "arrow.down.left.square",withConfiguration: SFSymbolConfig.smallConfig)?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            isFullScreen = false
            playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            btnFullScreen.setImage(UIImage(systemName: "rectangle",withConfiguration: SFSymbolConfig.smallConfig)?.withTintColor(.white,renderingMode: .alwaysOriginal), for: .normal)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    @objc func hideControls() {
        btnPlayPause.isHidden = true
        timeLine.isHidden = true
        lblTime.isHidden = true
        btnForward.isHidden = true
        btnBackward.isHidden = true
        btnFullScreen.isHidden = true
    }
    
    @objc func toggleControls() {
        btnPlayPause.isHidden = !btnPlayPause.isHidden
        btnBackward.isHidden = !btnBackward.isHidden
        btnForward.isHidden = !btnForward.isHidden
        timeLine.isHidden = !timeLine.isHidden
        lblTime.isHidden = !lblTime.isHidden
        btnFullScreen.isHidden = !btnFullScreen.isHidden
        resetTimer()
    }
}
