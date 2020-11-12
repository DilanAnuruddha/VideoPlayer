//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/11/20.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    //MARK: Components
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome to the My Player"
        lbl.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let txtUName = Components.createPaddingTextField(type: .emailAddress, placeHolder: "User Name")
    let txtUPassword = Components.createPaddingTextField(type: .password, placeHolder: "Password")
    
    let btnLogin:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log In", for: .normal)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.tintColor = .white
        btn.backgroundColor = .systemPink
        return btn
    }()
    
    let lblDescription:UILabel = {
        let lbl = UILabel()
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: "Doesn't have an account yet? ",
                                                   attributes: [.underlineStyle: 0]))
        attributedString.append(NSAttributedString(string: "Sign up",
                                                   attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]))
        lbl.attributedText = attributedString
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    let (loader,loaderBackground) = Components.getLoaderViewSet()
    
    //MARK: SetupUI
    func setupView()  {
        view.addSubViews(lblTitle,txtUName,txtUPassword,btnLogin,lblDescription)
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            txtUName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            txtUName.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            txtUName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            txtUPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            txtUPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            txtUPassword.topAnchor.constraint(equalTo: txtUName.bottomAnchor ,constant: 24),
            
            btnLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnLogin.widthAnchor.constraint(equalToConstant: 130),
            btnLogin.heightAnchor.constraint(equalToConstant: 40),
            btnLogin.topAnchor.constraint(equalTo: txtUPassword.bottomAnchor,constant: 32),
            
            lblDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            lblDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            lblDescription.topAnchor.constraint(equalTo: btnLogin.bottomAnchor ,constant: 24),
        ])
        btnLogin.addTarget(self, action: #selector(didClickedBtnLogin), for: .touchUpInside)
        lblDescription.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedLblDesc(_:))))
    }
}

//MARK:Functions
extension LoginViewController{
    
    @objc func didClickedBtnLogin(){
        Helper.validateLogin(uName: txtUName.text!, uPassword: txtUPassword.text!) { (response) in
            switch response{
            case .success(_):
                self.userLogin()
            case .failure(.emptyMail):Alert.showRequiredFieldAlert(on: self, message: "Email cannot be empty.")
            case .failure(.invalidMail):Alert.showRequiredFieldAlert(on: self, message: "Please enter valid email address.")
            case .failure(.emptyPassword):Alert.showRequiredFieldAlert(on: self, message: "Passowrd cannot be empty")
            default:break
            }
        }
    }
    
    @objc func didTappedLblDesc(_ sender: UITapGestureRecognizer){
        let vc = SignupViewController()
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
    
    fileprivate func userLogin(){
        if CheckConnection.isConnected() {
            let loginManager = FirebaseAuthManager()
            addLoaderToView(view: self.view, loader: loader, loaderBackground: loaderBackground)
            loginManager.signIn(email: txtUName.text!, pass: txtUPassword.text!) {(granted) in
                if granted {
                    self.removeLoader(loader: self.loader, loaderBackground: self.loaderBackground)
                    self.navigationController?.pushViewController(PlayerViewController(), animated: true)
                } else {
                    self.removeLoader(loader: self.loader, loaderBackground: self.loaderBackground)
                    Alert.showErrorAlert(on: self)
                }
            }
        }else{
            Alert.showNoConnectionAlert(on: self)
        }
    }
}

