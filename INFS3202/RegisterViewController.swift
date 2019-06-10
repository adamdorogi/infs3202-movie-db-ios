//
//  RegisterViewController.swift
//  INFS3202
//
//  Created by Adam Dorogi-Kaposi on 12/5/18.
//  Copyright © 2018 Adam Dorogi-Kaposi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let errorLabel = UILabel()
    var emailField = UITextField()
    var passwordField = UITextField()
    var confirmPasswordField = UITextField()
    var done: (() -> ())?
    var changeToLogin: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0)
        
        navigationItem.title = "Sign Up"
        
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
        emailField.frame.origin = CGPoint(x: (view.frame.width - emailField.frame.width) / 2, y: (view.frame.height) / 5)
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
        
        confirmPasswordField.textAlignment = .center
        confirmPasswordField.placeholder = "Confirm password"
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.keyboardAppearance = .dark
        confirmPasswordField.frame = passwordField.frame
        confirmPasswordField.frame.origin.y = passwordField.frame.origin.y + passwordField.frame.height + 16
        confirmPasswordField.backgroundColor = .white
        confirmPasswordField.layer.cornerRadius = confirmPasswordField.frame.height / 2
        view.addSubview(confirmPasswordField)
        
        let registerButton = UIButton(frame: confirmPasswordField.frame)
        registerButton.frame.origin.y = confirmPasswordField.frame.origin.y + confirmPasswordField.frame.height + 16
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.backgroundColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        registerButton.setTitle("Sign Up", for: .normal)
        registerButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        registerButton.setTitleColor(.black, for: .normal)
        view.addSubview(registerButton)
        
        let loginButton = UIButton(frame: registerButton.frame)
        loginButton.frame.origin.y = registerButton.frame.origin.y + registerButton.frame.height + 16
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle("Already have an account? Log in.", for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        loginButton.setTitleColor(UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0), for: .normal)
        view.addSubview(loginButton)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        cancelButton.tintColor = .white
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc func register() {
        let bodyData = "email=\(emailField.text!)&password=\(passwordField.text!)&confirmPassword=\(confirmPasswordField.text!)"
        
        Request().request(file: "register.php", bodyData: bodyData) { json in
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
    
    @objc func login() {
        self.dismiss(animated: true, completion: {
            self.changeToLogin!()
        })
    }

}
