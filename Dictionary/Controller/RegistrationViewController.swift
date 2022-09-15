//
//  RegistrationViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit
//import Firebase

class RegistrationViewController: UIViewController {
    
    // MARK: -> Properties
    
    private let emailTextField: UITextField = {
        let tf = Factories().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Factories().textField(withPlaceholder: "Password", isSecure: true)
        return tf
    }()
    
    private let fullnameTextField: UITextField = {
        let tf = Factories().textField(withPlaceholder: "Full Name")
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Factories().textField(withPlaceholder: "Username")
        return tf
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Factories().inputContainerView(withImage: (UIImage(systemName: "envelope") ?? UIImage(named: "mail"))!, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = Factories().inputContainerView(withImage: (UIImage(systemName: "lock") ?? UIImage(named: "ic_lock_outline_white_2x"))!, textField: passwordTextField)
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = Factories().inputContainerView(withImage: (UIImage(systemName: "person") ?? UIImage(named: "ic_person_outline_white_2x"))!, textField: fullnameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let view = Factories().inputContainerView(withImage: (UIImage(systemName: "person") ?? UIImage(named: "ic_person_outline_white_2x"))!, textField: usernameTextField)
        return view
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .white
        button.setDimensions(height: 50, width: nil)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyHaveAnAccountBtn: UIButton = {
        let btn = Factories().attributedButton("Already have an account?", " Log in")
        btn.addTarget(self, action: #selector(handleBackToLogin), for: .touchUpInside)
        return btn
    }()
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    // MARK: -> Selectors
    
    @objc func handleBackToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        AuthDataModel.shared.register(withEmail: email, password: password, username: username, fullname: fullname)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -> Configure/Helpers
    
    func configureUI(){
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        let inputStack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView])
        inputStack.axis = .vertical
        inputStack.spacing = 20
        
        view.addSubview(inputStack)
        inputStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(signUpButton)
        signUpButton.anchor(top: inputStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 36, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(alreadyHaveAnAccountBtn)
        alreadyHaveAnAccountBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8)
        alreadyHaveAnAccountBtn.centerX(inView: self.view)
    }
}
