//
//  RegisterController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/10/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterController: UIViewController {
    let accountCellID = "accountCellID"
    let passwordCellID = "passwordCellID"
    let userNameCellID = "userNameCellID"
    let registrationViewModel = RegistrationViewModel()
    let registerHUD = JGProgressHUD(style: .dark)
    var accountCell: AccountCell?
    var passwordCell: PasswordCell?
    var userNameCell: UserNameCell?
    
    lazy var uploadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "user256")
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.layer.borderColor = UIColor.themePink.cgColor
        imageView.layer.borderWidth = 3
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOpenAlbum))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    lazy var registerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AccountCell.self, forCellReuseIdentifier: accountCellID)
        tableView.register(PasswordCell.self, forCellReuseIdentifier: passwordCellID)
        tableView.register(UserNameCell.self, forCellReuseIdentifier: userNameCellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.specialWhite
        return tableView
    }()
    let registerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("註冊", for: UIControl.State.normal)
        button.backgroundColor = UIColor.themePink
        button.setTitleColor(.specialWhite, for: UIControl.State.normal)
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
        button.setTitleColor(UIColor.themePink, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.themePink.cgColor
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
        self.view.backgroundColor = .specialWhite
        setUpConstraints()
        addKeyboardObserver()
        setUpViewModelObserver()
    }
    override func viewDidAppear(_ animated: Bool) {addTarget()}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {self.view.endEditing(true)}
    
    func setUpConstraints(){
        self.view.addSubview(uploadingImageView)
        self.view.addSubview(registerTableView)
        self.view.addSubview(stackView)
        
        uploadingImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadingImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        uploadingImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        uploadingImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        registerTableView.topAnchor.constraint(equalTo: uploadingImageView.bottomAnchor, constant: 60).isActive = true
        registerTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        registerTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        registerTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        stackView.topAnchor.constraint(equalTo: registerTableView.bottomAnchor, constant: 40).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true
        
    }
    fileprivate func setUpViewModelObserver(){
        registrationViewModel.pickImageObserver = { [weak self] (userImage) in
            self?.uploadingImageView.image = userImage
        }
        registrationViewModel.isRegisteringObserver = { [weak self] (isRegistering) in
            guard let isRegistering = isRegistering else {return}
            if isRegistering{
                self?.showRegisterHUD()
            }else{
                self?.registerHUD.dismiss(afterDelay: 1)
            }
            
        }
    }
    @objc func handleOpenAlbum(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @objc func handleRegister(){
        guard let account = registrationViewModel.account,let password = registrationViewModel.password,let userName = registrationViewModel.userName else{return}
        registrationViewModel.isRegistering = true
        if userName.isEmpty || account.isEmpty || password.isEmpty{
                showErrorHUD(title: "錯誤", detail: "錯誤尚有欄位未輸入")
            }else{
                //新增帳號
                Auth.auth().createUser(withEmail: account, password: password) { (result, error) in
                    if let error = error{
                        let errorCode = (error as NSError).code
                        self.detectErrorCode(code: errorCode)
                    }else{
                        guard let userUID = result?.user.uid else{ return }
                        self.saveImageAndUserInfo(userUID: userUID, userName: userName, account: account)
                    }

                }
            }
    }
    fileprivate func showRegisterHUD(){
        registerHUD.textLabel.text = "驗證中"
        registerHUD.detailTextLabel.text = "請稍候"
        registerHUD.show(in: self.view, animated: true)
    }
    fileprivate func showErrorHUD(title: String,detail: String){
        registerHUD.dismiss(animated: true)
        let errorHUD = JGProgressHUD(style: .dark)
        errorHUD.textLabel.text = title
        errorHUD.detailTextLabel.text = detail
        errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
        errorHUD.show(in: self.view, animated: true)
        errorHUD.dismiss(afterDelay: 3, animated: true)
    }
    fileprivate func saveImageAndUserInfo(userUID: String,userName: String,account: String){
        let imageUID = NSUUID().uuidString
        guard let userImage = self.uploadingImageView.image?.jpegData(compressionQuality: 0.2) else{return}
        //圖片存進Storage,再從裡面抓出URL
        let imageRef = Storage.storage().reference().child("userImages").child(imageUID)
        imageRef.putData(userImage, metadata: nil, completion: { (metadata, error) in
            if let error = error{
                print("error:",error)
                return
            }
            //抓出在Storage的URL
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error{
                    print("error:",error)
                    return
                }
                
                let values: [String : Any] = ["uid" : userUID,
                                              "userName" : userName,
                                              "account" : account,
                                              "imageURL" : url?.absoluteString as Any]
                //需要一點時間,不能馬上切到UserInfo
                self.createUser(with: userUID, values: values)
            })
            
        })
        
    }
    
    

    fileprivate func addTarget(){
        let accountIndexPath = IndexPath(row: 0, section: 0)
        let passwordIndexPath = IndexPath(row: 0, section: 1)
        let userNameIndexPath = IndexPath(row: 0, section: 2)
        
        accountCell = registerTableView.cellForRow(at: accountIndexPath) as? AccountCell
        passwordCell = registerTableView.cellForRow(at: passwordIndexPath) as? PasswordCell
        userNameCell = registerTableView.cellForRow(at: userNameIndexPath) as? UserNameCell
        
        accountCell?.inputTextField.addTarget(self, action: #selector(handleInputChanged(textField:)), for: .editingChanged)
        passwordCell?.inputTextField.addTarget(self, action: #selector(handleInputChanged(textField:)), for: .editingChanged)
        userNameCell?.inputTextField.addTarget(self, action: #selector(handleInputChanged(textField:)), for: .editingChanged)
    }
    @objc fileprivate func handleInputChanged(textField: UITextField){
        if textField == accountCell?.inputTextField{
            registrationViewModel.account = textField.text
        }else if textField == passwordCell?.inputTextField{
            registrationViewModel.password = textField.text
        }else{
            registrationViewModel.userName = textField.text
        }
    }
    func createUser(with uid: String,values: [String : Any]){
        let ref = Database.database().reference().child("使用者").child(uid)
        ref.setValue(values) { (error, metaData) in
            if let error = error{
                print("error:",error)
                return
            }
            self.registrationViewModel.isRegistering = false
            //dismiss所有的Controller,回到根畫面
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setIsLogIn(value: true)
        }
    }
    func detectErrorCode(code: Int){
        switch code {
        case 17007:
            showErrorHUD(title: "錯誤", detail: "帳號已被使用")
        case 17008:
            showErrorHUD(title: "錯誤", detail: "帳號格式不符")
        case 17020:
            showErrorHUD(title: "錯誤", detail: "請檢查網路")
        case 17026:
            showErrorHUD(title: "錯誤", detail: "密碼不足6位數")
        default:
            return
        }
    }
    func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - Selector方法
    @objc func handleCancel(){self.dismiss(animated: true, completion: nil)}
    @objc func handleKeyboardShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let bottomSpace = self.view.frame.height - stackView.frame.origin.y - stackView.frame.height
            let difference = keyboardHeight - bottomSpace
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
            }, completion: nil)
            
        }
    }
    @objc func handleKeyboardHide(_ notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

//MARK: - 相簿存取
extension RegisterController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //完成選取
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let getImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        registrationViewModel.userImage = getImage
    }
    //按下取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
//MARK: - TableView設定
extension RegisterController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 0{
            cell = registerTableView.dequeueReusableCell(withIdentifier: accountCellID, for: indexPath) as! AccountCell
        }else if indexPath.section == 1{
            cell = registerTableView.dequeueReusableCell(withIdentifier: passwordCellID, for: indexPath) as! PasswordCell
        }else{
            cell = registerTableView.dequeueReusableCell(withIdentifier: userNameCellID, for: indexPath) as! UserNameCell
        }
        return cell
    }
    //Header高
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    //Footer高
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    //Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let titleLabel = UILabel(frame: CGRect(x: 3, y: 3, width: 100, height: 10))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        switch section{
        case 0: titleLabel.text = "帳號"
        case 1: titleLabel.text = "密碼"
        case 2: titleLabel.text = "暱稱"
        default : fatalError("Invalid Section")
        }
        titleLabel.textColor = .themePink
        view.addSubview(titleLabel)
        
        return view
    }
    //Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
