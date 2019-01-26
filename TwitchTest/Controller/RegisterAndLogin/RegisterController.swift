//
//  RegisterController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/10/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

import JGProgressHUD

class RegisterController: UIViewController {
    
    lazy var uploadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "user256")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = specialYellow
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = specialYellow.cgColor
        imageView.layer.borderWidth = 3
        imageView.isUserInteractionEnabled = true
        //手勢
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenAlbum))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    let label_1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "帳號"
        label.textColor = specialYellow
        return label
    }()
    let accountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = specialYellow
        textField.attributedPlaceholder = NSAttributedString(string: "設定帳號...", attributes: [NSAttributedString.Key.foregroundColor : specialYellow])
        return textField
    }()
    let bottomLine_1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = specialYellow
        return view
    }()
    //
    let label_2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "密碼"
        
        label.textColor = specialYellow
        return label
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "設定密碼(至少六位數)...", attributes: [NSAttributedString.Key.foregroundColor : specialYellow])
        textField.backgroundColor = UIColor.clear
        textField.textColor = specialYellow
        textField.isSecureTextEntry = true
        return textField
    }()
    let bottomLine_2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = specialYellow
        return view
    }()
    //
    let label_3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "暱稱"
        label.textColor = specialYellow
        return label
    }()
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "設定暱稱...", attributes: [NSAttributedString.Key.foregroundColor : specialYellow])
        textField.backgroundColor = UIColor.clear
        textField.textColor = specialYellow
        return textField
    }()
    let bottomLine_3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = specialYellow
        return view
    }()
    //
    let registerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("註冊", for: UIControl.State.normal)
        button.backgroundColor = specialYellow
        button.setTitleColor(themeGrayColor, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("取消", for: UIControl.State.normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(specialYellow, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = specialYellow.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(cancelButton)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = themeGrayColor
        
        self.view.addSubview(uploadingImageView)
        self.view.addSubview(label_1)
        self.view.addSubview(accountTextField)
        self.view.addSubview(bottomLine_1)
        self.view.addSubview(label_2)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(bottomLine_2)
        self.view.addSubview(label_3)
        self.view.addSubview(userNameTextField)
        self.view.addSubview(bottomLine_3)
        
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
        
        uploadingImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadingImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaHeight_Top + 70).isActive = true
        uploadingImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        uploadingImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        label_1.topAnchor.constraint(equalTo: uploadingImageView.bottomAnchor, constant: 70).isActive = true
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
        
        label_3.topAnchor.constraint(equalTo: bottomLine_2.bottomAnchor, constant: 15).isActive = true
        label_3.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor).isActive = true
        
        userNameTextField.topAnchor.constraint(equalTo: label_3.bottomAnchor, constant: 5).isActive = true
        userNameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userNameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomLine_3.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        bottomLine_3.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        bottomLine_3.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor).isActive = true
        bottomLine_3.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        
        stackView.topAnchor.constraint(equalTo: bottomLine_3.bottomAnchor, constant: 50).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        
        
    }
    @objc func handleOpenAlbum(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @objc func handleRegister(){
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "驗證中..."
        hud.show(in: self.view)
        if let userName = userNameTextField.text,let account = accountTextField.text,let password = passwordTextField.text{
            if userName.isEmpty || account.isEmpty || password.isEmpty{
                hud.dismiss(afterDelay: 1)
                Alert.alert_BugReport(message: "尚有欄位未輸入", title: "錯誤", with: self)
            }else{
                //新增帳號
                Auth.auth().createUser(withEmail: account, password: password) { (result, error) in
                    if let error = error{
                        hud.dismiss(afterDelay: 1)
                        let errorCode = (error as NSError).code
                        self.detectErrorCode(code: errorCode)
                    }else{
                        let imageUID = NSUUID().uuidString
                        guard let userImage = self.uploadingImageView.image?.jpegData(compressionQuality: 0.2) else{return}
                        //圖片存進Storage,再從裡面抓出URL
                        let ref = Storage.storage().reference().child("userImages").child(imageUID)
                        ref.putData(userImage, metadata: nil, completion: { (metadata, error) in
                            if let error = error{
                                print("error:",error)
                            }
                            //抓出在Storage的URL
                            ref.downloadURL(completion: { (url, error) in
                                if let error = error{
                                    print("error:",error)
                                }
                                //新增user後,user有自帶的uid
                                guard let userUID = result?.user.uid else{return}
                                let values: [String : Any] = ["userName" : userName,
                                                              "account" : account,
                                                              "imageURL" : url?.absoluteString as Any,
                                                              "numbersOfArticle" : 0]
                                self.addUserToDataBase(uid: userUID, values: values)
                            })

                        })
                       
                        
                        
                        hud.dismiss(afterDelay: 1)
                        //dismiss所有的Controller,回到根畫面
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                         UserDefaults.standard.setIsLogIn(value: true)
                    }
                    
                }
            }
        }
    }
    
    
    func addUserToDataBase(uid: String,values: [String : Any]){
        let ref = Database.database().reference().child("使用者").child(uid)
        ref.setValue(values) { (error, metaData) in
            if let error = error{
                print("error:",error)
            }
        }
    }
    func detectErrorCode(code: Int){
        switch code {
        case 17007:
            Alert.alert_BugReport(message: "帳號已被使用", title: "錯誤", with: self)
        case 17008:
            Alert.alert_BugReport(message: "帳號格式不符", title: "錯誤", with: self)
        case 17026:
            Alert.alert_BugReport(message: "密碼不足6位數", title: "錯誤", with: self)
        default:
            return
        }
    }
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
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

//相簿存取
extension RegisterController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //完成選取
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let getImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        uploadingImageView.image = getImage
    }
    //按下取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
