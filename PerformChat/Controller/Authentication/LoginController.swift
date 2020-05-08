//
//  LoginController.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 17/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol AutheticationControllerProtocol {
    func checkFormStatus()
}

class LoginController: UIViewController {
    
    //MARK: - Propeties
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var emailContainerView: inputContainerView = {
        return inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private lazy var pwdContainerView: inputContainerView = {
        return inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: pwdTextField)
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Entrar", for: .normal)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        btn.setHeight(height: 50)
        return btn
    }()
    
    private let emailTextField: CustomTextField = {
        return CustomTextField(placeholder: "Email")
    }()
    
    private let pwdTextField: CustomTextField = {
        let txt = CustomTextField(placeholder: "Senha")
        txt.isSecureTextEntry = true
        return txt 
    }()
    
    private let dontHaveAccountBtn: UIButton = {
        let btn = UIButton(type: .system)
        let atribbuted = NSMutableAttributedString(string: "Nāo possui conta?", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        atribbuted.append(NSAttributedString(string: " Cadastre-se", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        btn.setAttributedTitle(atribbuted, for: .normal)
        btn.addTarget(self, action: #selector(showScreenSignUp), for: .touchUpInside)
        return btn
    }()
    
    var textFields: [CustomTextField] {
        return [emailTextField,pwdTextField]
    }
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextViewDelegates()
        configureInterface()
    }
    
    //MARK: - Selectors
    
    @objc func showScreenSignUp() {
        let controller = RegisterController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textChanged(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.pwd = sender.text
        }
        checkFormStatus()
    }
    
    @objc func login() {
        guard let email = emailTextField.text else { return }
        guard let pwd = pwdTextField.text else { return }
        
        showLoader(true)
        
        AuthService.shared.loginUser(email: email, pwd: pwd) { response, error in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
            } else {
                self.showLoader(false)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureInterface() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView,pwdContainerView,loginBtn])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountBtn)
        dontHaveAccountBtn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 16, paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        pwdTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    
    func configureTextViewDelegates() {
        textFields.forEach { $0.delegate = self }
    }
}

extension LoginController: AutheticationControllerProtocol {
    
    //MARK: - Protocols
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}

//MARK: - UITextFieldDelegate

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField as! CustomTextField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
