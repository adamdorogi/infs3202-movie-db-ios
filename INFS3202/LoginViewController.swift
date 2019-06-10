//
//  LoginViewController.swift
//  INFS3202
//
//  Created by Adam Dorogi-Kaposi on 12/5/18.
//  Copyright © 2018 Adam Dorogi-Kaposi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let errorLabel = UILabel()
    var emailField = UITextField()
    var passwordField = UITextField()
    var done: (() -> ())?
    var changeToSignUp: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0)
        
        navigationItem.title = "Log In"
        
        errorLabel.frame.size = CGSize(width: view.frame.width, height: 32)
        errorLabel.frame.origin = CGPoint(x: 0, y: 112)
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor(red: 255/255, green: 58/255, blue: 49/255, alpha: 1.0)
        errorLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(errorLabel)
        
        emailField.textAlignment = .center
        emailField.placeholder = "Email"
        emailField.keyboardType = .emailAddress
        emailField.keyboardAppearance = .dark
        emailField.frame.size = CGSize(width: 256, height: 48)
        emailField.frame.origin = CGPoint(x: (view.frame.width - emailField.frame.width) / 2, y: (view.frame.height) / 4)
        emailField.backgroundColor = .white
        emailField.layer.cornerRadius = emailField.frame.height / 2
        view.addSubview(emailField)
        
        passwordField.textAlignment = .center
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.keyboardAppearance = .dark
        passwordField.frame = emailField.frame
        passwordField.frame.origin.y = emailField.frame.origin.y + emailField.frame.height + 16
        passwordField.backgroundColor = .white
        passwordField.layer.cornerRadius = passwordField.frame.height / 2
        view.addSubview(passwordField)
        
        let loginButton = UIButton(frame: passwordField.frame)
        loginButton.frame.origin.y = passwordField.frame.origin.y + passwordField.frame.height + 16
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.backgroundColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        loginButton.setTitleColor(.black, for: .normal)
        view.addSubview(loginButton)
        
        let signUpButton = UIButton(frame: loginButton.frame)
        signUpButton.frame.origin.y = loginButton.frame.origin.y + loginButton.frame.height + 16
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        signUpButton.setTitle("Don't have an account? Sign up.", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        signUpButton.setTitleColor(UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0), for: .normal)
        view.addSubview(signUpButton)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        cancelButton.tintColor = .white
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc func login() {
        let bodyData = "email=\(emailField.text!)&password=\(passwordField.text!)"

        Request().request(file: "login.php", bodyData: bodyData) { json in
            DispatchQueue.main.async {
                if json[0]["status"] as! String == "success" {
                    self.dismiss(animated: true, completion: {
                        self.done!()
                    })
                } else {
                    self.errorLabel.text = json[0]["message"] as? String
                }
            }
        }
    }
    
    @objc func signUp() {
        self.dismiss(animated: true, completion: {
            self.changeToSignUp!()
        })
    }
}

