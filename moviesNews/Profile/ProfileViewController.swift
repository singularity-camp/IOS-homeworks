//
//  ProfileViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 16.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var loginText: String?
    private var passwordText: String?
    private var networkManager = NetworkManager.shared

    private lazy var loginField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Login"
        textField.borderStyle = .roundedRect
        return textField
    }()
    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .gray
        return button
    }()
    private let eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .black
        return button
    }()
    
    let alertT = UIAlertController(title: "Error", message: "Probabbly your credentials are wrong!", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        // handle response here.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        alertT.addAction(OKAction)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        eyeButton.addTarget(self, action: #selector(didTapEye), for: .touchUpInside)
        
        [loginField, passwordField, loginButton].forEach {
            view.addSubview($0)
        }
        
        loginField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        passwordField.rightView = eyeButton
        passwordField.rightViewMode = .always
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(loginField.snp.bottom).offset(16)
            make.left.right.equalTo(loginField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(24)
            make.left.right.equalTo(loginField)
            make.height.equalTo(50)
        }
    }
    
    @objc private func didTapLogin() {
        loginText = loginField.text
        passwordText = passwordField.text
        print("Login is: \(loginText) and password: \(passwordText)")
        
        guard let loginText, let passwordText else {return}
        networkManager.getRequestToken { [weak self] result in
            switch result {
            case .success(let dataModel):
                if dataModel.success {
                    let requestData: ValidateAuthenticationModel = .init(
                        username: loginText,
                        password: passwordText,
                        requestToken: dataModel.requestToken)
                    self?.networkManager.validateWithLogin(requestBody: requestData.toDictionary()) { [weak self] result in
                        self?.validateWithLogin(with: requestData)
                    }
                }
            case .failure:
                self?.tabBarController?.present(self!.alertT, animated: true)
                break
            }
        }
    }
    
    private func validateWithLogin(with data: ValidateAuthenticationModel) {
        networkManager.validateWithLogin(requestBody: data.toDictionary()) { [weak self] result in
            switch result {
            case .success(let dataModel):
                if dataModel.success {
                    let requestData = ["request_token": dataModel.requestToken]
                    self?.createSession(with: requestData)
                }
            case .failure:
                self?.tabBarController?.present(self!.alertT, animated: true)
                break
            }
        }
    }
    
    private func createSession(with requestBody: [String: Any]) {
        networkManager.createSession(requestBody: requestBody) { [weak self] result in
            switch result {
            case .success(let sessionId):
                print("My sessionId is \(sessionId)")
            case .failure:
                self?.tabBarController?.present(self!.alertT, animated: true)
                break
            }
        }
    }
    
    @objc private func didTapEye() {
        passwordField.isSecureTextEntry.toggle()
        let image = passwordField.isSecureTextEntry ? UIImage(systemName: "eye") : UIImage(systemName: "eye.slash")
        eyeButton.setImage(image, for: .normal)
    }
}


