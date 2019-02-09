//
//  LoginController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/9/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import JGProgressHUD



let themeColor = UIColor(red: 252/255, green: 81/255, blue: 133/255, alpha: 1)
let darkHeartColor = UIColor(red: 233/255, green: 47/255, blue: 96/255, alpha: 1)
let specialWhite = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
let specialCyan = UIColor(red: 63/255, green: 193/255, blue: 201/255, alpha: 1)
let specialGray = UIColor(red: 228/255, green: 231/255, blue: 233/255, alpha: 1)
let specialGray2 = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
let shadowGray = UIColor(red: 120/255, green: 121/255, blue: 122/255, alpha: 1.0)

let safeAreaHeight_Top = UIApplication.shared.keyWindow!.safeAreaInsets.top
let safeAreaHeight_Bottom = UIApplication.shared.keyWindow!.safeAreaInsets.bottom


class LoginController: UIViewController {
    
    
    let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "unboxing")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = themeColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let sloganLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "開箱趣"
        label.textColor = themeColor
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    let accountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = themeColor
        textField.attributedPlaceholder = NSAttributedString(string: "輸入帳號...", attributes: [NSAttributedString.Key.foregroundColor : themeColor])
        return textField
    }()
    let label_1: UILabel = {
      let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "帳號"
        label.textColor = themeColor
        return label
    }()
    let label_2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "密碼"
        
        label.textColor = themeColor
        return label
    }()
    let bottomLine_1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColor
        return view
    }()
    let bottomLine_2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = themeColor

        return view
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "輸入密碼...", attributes: [NSAttributedString.Key.foregroundColor : themeColor])
        textField.backgroundColor = UIColor.clear
        textField.textColor = themeColor
        textField.isSecureTextEntry = true
        return textField
    }()
    let loginButton: UIButton = {
       let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("登入", for: UIControl.State.normal)
        button.backgroundColor = themeColor

       
        
        button.setTitleColor(specialWhite, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    let registerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("註冊", for: UIControl.State.normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(themeColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = themeColor.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(registerButton)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = specialWhite
        
        self.view.addSubview(logoImageView)
        self.view.addSubview(sloganLabel)
        self.view.addSubview(label_1)
        self.view.addSubview(accountTextField)
        self.view.addSubview(bottomLine_1)
        self.view.addSubview(label_2)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(bottomLine_2)
        self.view.addSubview(stackView)
        
        accountTextField.text = "Asiagodtone@q.com"
        passwordTextField.text = "Qqqqqq"
        
        setUpConstraints()
        addKeyboardObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func setUpConstraints(){
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaHeight_Top + 80).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        sloganLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sloganLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10).isActive = true
        
        label_1.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 70).isActive = true
        label_1.leftAnchor.constraint(equalTo: accountTextField.leftAnchor).isActive = true
        
        
        accountTextField.topAnchor.constraint(equalTo: label_1.bottomAnchor, constant: 5).isActive = true
        accountTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        accountTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        accountTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomLine_1.topAnchor.constraint(equalTo: accountTextField.bottomAnchor).isActive = true
        bottomLine_1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bottomLine_1.widthAnchor.constraint(equalTo: accountTextField.widthAnchor).isActive = true
        bottomLine_1.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        label_2.topAnchor.constraint(equalTo: bottomLine_1.bottomAnchor, constant: 15).isActive = true
        label_2.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor).isActive = true
        
        
        passwordTextField.topAnchor.constraint(equalTo: label_2.bottomAnchor, constant: 5).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomLine_2.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        bottomLine_2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bottomLine_2.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        bottomLine_2.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        
        stackView.topAnchor.constraint(equalTo: bottomLine_2.bottomAnchor, constant: 50).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        

    }
    
    
    func detectErrorCode(code: Int){
        switch code {
        case 17008:
            Alert.alert_BugReport(message: "帳號格式不符", title: "錯誤", with: self)
        case 17009:
            Alert.alert_BugReport(message: "密碼錯誤", title: "錯誤", with: self)
        case 17011:
            Alert.alert_BugReport(message: "帳號尚未註冊", title: "錯誤", with: self)
        case 17020:
            Alert.alert_BugReport(message: "請檢查網路連線", title: "錯誤", with: self)
        default:
            return
        }
    }
    func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - Selector方法
    @objc func handleLogin(){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "登入中..."
        hud.show(in: self.view, animated: true)
        if let account = accountTextField.text,let password = passwordTextField.text{
            if account.isEmpty || password.isEmpty{
                hud.dismiss(afterDelay: 1)
                Alert.alert_BugReport(message: "尚有欄位未輸入", title: "錯誤", with: self)
                
            }else{
                Auth.auth().signIn(withEmail: account, password: password) { (result, error) in
                    if let error = error{
                        hud.dismiss(afterDelay: 1)
                        
                        let errorCode = (error as NSError).code
                        print(errorCode)
                        self.detectErrorCode(code: errorCode)
                    }else{
                        hud.dismiss(animated: true)
                        UserDefaults.standard.setIsLogIn(value: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
                
            }
        }
    }
    @objc func handleRegister(){
        self.present(RegisterController(), animated: true, completion: nil)
    }
    
    @objc func handleKeyboardShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame = CGRect(x: 0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
            
        }
    }
    @objc func handleKeyboardHide(_ notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.width + 5, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.width + 5, height: bounds.height)
    }
    
}
