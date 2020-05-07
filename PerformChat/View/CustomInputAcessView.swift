//
//  CustomInputAcessView.swift
//  PerformChat
//
//  Created by Guilherme. Duarte on 20/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

protocol CustomInputAcessViewDelegate: class {
    func inputView(_ inputView: CustomInputAcessView, message: String)
}

class CustomInputAcessView: UIView {
    
    //MARK: - Propeties
    
    weak var delegate: CustomInputAcessViewDelegate?
    
    private lazy var txtInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Enviar", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.systemPurple, for: .normal)
        btn.addTarget(self, action: #selector(sendMessageTouch), for: .touchUpInside)
        return btn
    }()
    
    private let placeholderLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Digite aqui"
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sendBtn)
        sendBtn.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendBtn.setDimensions(height: 50, width: 50)
        
        addSubview(txtInputTextView)
        txtInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendBtn.leftAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 4, paddingRight: 8)
        
        addSubview(placeholderLbl)
        placeholderLbl.anchor(left: txtInputTextView.leftAnchor, paddingLeft: 4)
        placeholderLbl.centerY(inView: txtInputTextView)
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(txtInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Selectors
    
    @objc func sendMessageTouch() {
        guard let text = txtInputTextView.text else { return }
        delegate?.inputView(self, message: text)
    }
    
    @objc func txtInputChange() {
        placeholderLbl.isHidden = !self.txtInputTextView.text.isEmpty
    }
    
    //MARK: - Helpers
    
    func clearMessageText() {
        txtInputTextView.text = nil
        placeholderLbl.isHidden = false
    }
    
}
