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

    let registrationViewModel = RegistrationViewModel()
    let registerHUD = JGProgressHUD(style: .dark)
    var accountCell: AccountCell?
    var passwordCell: PasswordCell?
    var userNameCell: UserNameCell?
    
    lazy var uploadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("選擇照片", for: .normal)
        button.setTitleColor(.themePink, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 100
        button.layer.borderColor = UIColor.themePink.cgColor
        button.layer.borderWidth = 3
        button.addTarget(self, action: #selector(handleOpenAlbum), for: .touchUpInside)
        return button
    }()

    lazy var registerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.specialWhite
        tableView.isScrollEnabled = false
        return tableView
    }()
    let registerButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("註冊", for: UIControl.State.normal)
        button.backgroundColor = UIColor.themePink
        button.setTitleColor(.specialWhite, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
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
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.themePink.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(registerTableView)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(cancelButton)
        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .specialWhite
        setUpConstraints()
        setUpViewModelObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTextfieldTarget()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func setUpConstraints(){
        self.view.addSubViews(with: uploadImageButton,stackView)
        
        uploadImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadImageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        uploadImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        uploadImageButton.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        stackView.topAnchor.constraint(equalTo: uploadImageButton.bottomAnchor, constant: 40).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    fileprivate func setUpViewModelObserver(){
        registrationViewModel.pickImageObserver = { [weak self] (userImage) in
            self?.uploadImageButton.setImage(userImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        registrationViewModel.isRegisteringObserver = { [weak self] (isRegistering) in
            guard let isRegistering = isRegistering else {return}
            if isRegistering{
                self?.showRegisterHUD()
            }else{
                self?.registerHUD.dismiss(animated: true)
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
        self.view.endEditing(true)
        registrationViewModel.isRegistering = true
        registrationViewModel.performRegister { [weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .failure(let error):
                self.registrationViewModel.isRegistering = false
                JGProgressHUD.showErrorHUD(in: self.view, detail: error.localizedDescription)
            case .success(let values):
                self.registrationViewModel.isRegistering = false
                guard let userUID = values["uid"] as? String else{return}
                self.createUser(with: userUID, values: values)
            }
        }
    }
    fileprivate func showRegisterHUD(){
        registerHUD.textLabel.text = "驗證中"
        registerHUD.detailTextLabel.text = "請稍候"
        registerHUD.show(in: self.view, animated: true)
    }
    fileprivate func saveImageAndUserInfo(userUID: String,userName: String,account: String){
        let imageUID = NSUUID().uuidString
        guard let userImage = self.uploadImageButton.currentImage?.jpegData(compressionQuality: 0.2) else{return}
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
    
    

    fileprivate func addTextfieldTarget(){
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
                self.registerHUD.dismiss(animated: true)
                JGProgressHUD.showErrorHUD(in: self.view, detail: error.localizedDescription)
                return
            }
            self.registrationViewModel.isRegistering = false
            //dismiss所有的Controller,回到根畫面
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            let vc = navigationController?.viewControllers.first as? AllCommodityCollectionViewController
            vc?.fetchCurrentUserInfo()
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            UserDefaults.standard.setIsLogIn(value: true)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let getImage = info[.editedImage] as! UIImage
        registrationViewModel.userImage = getImage
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
            cell = AccountCell(style: .default, reuseIdentifier: nil)
        }else if indexPath.section == 1{
            cell = PasswordCell(style: .default, reuseIdentifier: nil)
        }else{
            cell = UserNameCell(style: .default, reuseIdentifier: nil)
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
        titleLabel.textColor = .themePink
        switch section{
        case 0: titleLabel.text = "帳號"
        case 1: titleLabel.text = "密碼"
        default : titleLabel.text = "暱稱"
        }
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
