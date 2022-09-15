//
//  LoginViewController.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: -> Properties
    
    private let titleLb: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 24, weight: .bold)
        lb.textColor = dynamicColor
        lb.text = "Dictionary"
        lb.textAlignment = .center
        return lb
    }()
    
    private let emailTextField: UITextField = {
        let tf = Factories().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Factories().textField(withPlaceholder: "Password", isSecure: true)
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .white
        button.setDimensions(height: 50, width: nil)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveAccountBtn: UIButton = {
        let btn = Factories().attributedButton("Don't have an account?", " Sign Up")
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return btn
    }()
    
    // MARK: -> LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    // MARK: -> Selectors
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        AuthDataModel.shared.login(withEmail: email, password: password) {
            self.navigationController?.pushViewController(TabBarViewController(), animated: true)
        }
    }
    
    @objc func handleShowSignUp(){
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    // MARK: -> Configure/Helpers
    
    func configureUI(){
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.isHidden = true
        
        self.view.addSubview(titleLb)
        titleLb.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        titleLb.centerY(inView: self.view, constant: -100)
        
        let inputStack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        inputStack.axis = .vertical
        inputStack.spacing = 20
        
        view.addSubview(inputStack)
        inputStack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        inputStack.centerY(inView: self.view)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: inputStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 36, paddingLeft: 24, paddingRight: 24)
        
        view.addSubview(dontHaveAccountBtn)
        dontHaveAccountBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8)
        dontHaveAccountBtn.centerX(inView: self.view)
    }
}
