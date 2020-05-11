//
//  RegisterController.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 17/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    //MARK: - Propeties
    
    private var viewModel = RegisterViewModel()
    private var profileImage: UIImage?
    
    private let btnChangePhoto: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(changePhoto), for: .touchUpInside)
        btn.imageView?.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        return btn
    }()
    
    private let signUpBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cadastrar", for: .normal)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(signUpTouch), for: .touchUpInside)
        btn.setHeight(height: 50)
        return btn
    }()
    
    private let haveAccountBtn: UIButton = {
        let btn = UIButton(type: .system)
        let atribbuted = NSMutableAttributedString(string: "Já possui conta?", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        atribbuted.append(NSAttributedString(string: " Entre", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        btn.setAttributedTitle(atribbuted, for: .normal)
        btn.addTarget(self, action: #selector(showScreenLogin), for: .touchUpInside)
        return btn
    }()
    
    private lazy var emailContainerView: inputContainerView = {
        return inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)

    }()
    
    private lazy var fullNameContainerView: inputContainerView = {
        return inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNmeTextField)
    }()
    
    private lazy var usernameContainerView: inputContainerView = {
        return inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: usernameTextField)
    }()
    
    private lazy var pwdContainerView: inputContainerView = {
        return inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: pwdTextField)
    }()
    
    private let emailTextField: CustomTextField = {
        let txt = CustomTextField(placeholder: "Email")
        txt.textContentType = .emailAddress
        txt.keyboardType = .emailAddress
        return txt
    }()
    
    private let fullNmeTextField: CustomTextField = {
        let txt = CustomTextField(placeholder: "Nome Completo")
        txt.textContentType = .name
        txt.keyboardType = .default
        return txt
    }()
    
    private let usernameTextField: CustomTextField = {
        let txt = CustomTextField(placeholder: "Apelido")
        txt.textContentType = .username
        txt.keyboardType = .default
        return txt
    }()
    
    private let pwdTextField: CustomTextField = {
        let txt = CustomTextField(placeholder: "Senha")
        txt.isSecureTextEntry = true
        txt.textContentType = .password
        txt.keyboardType = .default
        return txt
    }()
    
    var textFields: [CustomTextField] {
        return [emailTextField, fullNmeTextField, usernameTextField, pwdTextField]
        
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        configureNotifications()
        configureTextViewDelegates()
    }
    
    
    //MARK: - Selectors
    
    @objc func signUpTouch() {
        if emailTextField.text == "" || pwdTextField.text == "" || fullNmeTextField.text == "" || usernameTextField.text == "" || profileImage == nil {self.showError("Verifique os campos")}

        guard let email = emailTextField.text else { return }
        guard let pwd = pwdTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let fullname = fullNmeTextField.text else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = RegistrationCredential(email: email, pwd: pwd, fullname: fullname, username: username, profileImage: profileImage)
        
        showLoader(true)
        AuthService.shared.registerUser(credentials: credentials) { error in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
            } else {
                self.showLoader(false)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func textChanged(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == pwdTextField {
            viewModel.pwd = sender.text
        } else if sender == fullNmeTextField {
            viewModel.fullname = sender.text
        } else if sender == usernameTextField {
            viewModel.usename = sender.text
        }
        checkFormStatus()
    }
    
    @objc func keyboardShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardHide() {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func changePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func showScreenLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers
    
    func configureInterface() {
        configureGradientLayer()
        
        view.addSubview(btnChangePhoto)
        btnChangePhoto.centerX(inView: view)
        btnChangePhoto.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        btnChangePhoto.setDimensions(height: 200, width: 200)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView,fullNameContainerView,usernameContainerView,pwdContainerView,signUpBtn])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: btnChangePhoto.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(haveAccountBtn)
        haveAccountBtn.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 16, paddingRight: 32)
        

        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 280, width: screenWidth, height: screenHeight - 380))

        scrollView.addSubview(stackView)

        NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: screenWidth - 42).isActive = true

        scrollView.contentSize = CGSize(width: screenWidth, height: 450)
        view.addSubview(scrollView)
    }
    
    func configureNotifications() {
        emailTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        pwdTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        fullNmeTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureTextViewDelegates() {
        textFields.forEach { $0.delegate = self }
    }
    
}


extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Picker View Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        btnChangePhoto.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnChangePhoto.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        btnChangePhoto.layer.borderWidth = 3.0
        btnChangePhoto.layer.cornerRadius = 200 / 2
        
        dismiss(animated: true, completion: nil)
    }
}


extension RegisterController: AutheticationControllerProtocol {
    
    //MARK: - Protocols
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpBtn.isEnabled = true
            signUpBtn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            signUpBtn.isEnabled = false
            signUpBtn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}

//MARK: - UITextFieldDelegate

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField as! CustomTextField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
