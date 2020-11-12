//
//  SignupViewController.swift
//  VideoPlayer
//
//  Created by Dilan Anuruddha on 11/12/20.
//

import UIKit

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        setupView()
    }
    
    //MARK: Components
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign Up"
        lbl.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        lbl.textColor = .white
        return lbl
    }()
    
    let txtUName = Components.createPaddingTextField(type: .emailAddress, placeHolder: "Email Address")
    let txtUPassword = Components.createPaddingTextField(type: .password, placeHolder: "Password")
    let txtUConfirm = Components.createPaddingTextField(type: .password, placeHolder: "Confirm Password")
    
    let btnSignup:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.tintColor = .white
        btn.backgroundColor = .systemPink
        return btn
    }()
    
    let (loader,loaderBackground) = Components.getLoaderViewSet()
    
    //MARK: Setup UI
    func setupView()  {
        view.addSubViews(lblTitle,txtUName,txtUPassword,txtUConfirm,btnSignup)
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            txtUName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            txtUName.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            txtUName.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 120),
            
            txtUPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            txtUPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            txtUPassword.topAnchor.constraint(equalTo: txtUName.bottomAnchor ,constant: 24),
            
            txtUConfirm.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            txtUConfirm.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            txtUConfirm.topAnchor.constraint(equalTo: txtUPassword.bottomAnchor ,constant: 24),
            
            btnSignup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnSignup.widthAnchor.constraint(equalToConstant: 130),
            btnSignup.heightAnchor.constraint(equalToConstant: 40),
            btnSignup.topAnchor.constraint(equalTo: txtUConfirm.bottomAnchor,constant: 32),
        ])
        btnSignup.addTarget(self, action: #selector(didClickedBtnSignup), for: .touchUpInside)
    }
}

//MARK: Functions
extension SignupViewController {
    
    @objc func didClickedBtnSignup(){
        Helper.validateSignup(uName: txtUName.text!, uPassword: txtUPassword.text!, uConfirm: txtUConfirm.text!) { (response) in
            switch response{
            case .success(_):
                self.signUp()
            case .failure(.emptyMail):Alert.showRequiredFieldAlert(on: self, message: "Email cannot be empty.")
            case .failure(.invalidMail):Alert.showRequiredFieldAlert(on: self, message: "Please enter valid email address.")
            case .failure(.emptyPassword):Alert.showRequiredFieldAlert(on: self, message: "Passowrd cannot be empty")
            case .failure(.mismatchPassword):Alert.showRequiredFieldAlert(on: self, message: "Password confirmation incorrect or empty.")
            }
        }
    }
    
    fileprivate func signUp(){
        if CheckConnection.isConnected() {
            addLoaderToView(view: self.view, loader: loader, loaderBackground: loaderBackground)
            let signUpManager = FirebaseAuthManager()
            signUpManager.createUser(email: txtUName.text!, password: txtUPassword.text!) { (granted) in
                if granted{
                    self.removeLoader(loader: self.loader, loaderBackground: self.loaderBackground)
                    Alert.showDefaultAlert(on: self, title: "SUCCESS", message: "User was sucessfully created")
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.removeLoader(loader: self.loader, loaderBackground: self.loaderBackground)
                    Alert.showErrorAlert(on: self)
                }
            }
        }else{
            Alert.showNoConnectionAlert(on: self)
        }
    }
}
