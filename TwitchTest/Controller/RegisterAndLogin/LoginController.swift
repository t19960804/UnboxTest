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


let safeAreaHeight_Top = UIApplication.shared.keyWindow!.safeAreaInsets.top
let safeAreaHeight_Bottom = UIApplication.shared.keyWindow!.safeAreaInsets.bottom


class LoginController: UIViewController {
    
    let cellID = "Cell"
    let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "unboxing")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.themePink
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let sloganLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "開箱趣"
        label.textColor = UIColor.themePink
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    lazy var loginTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LoginCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = UIColor.specialWhite
        return tableView
    }()
    let loginButton: UIButton = {
       let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("登入", for: UIControl.State.normal)
        button.backgroundColor = UIColor.themePink
        button.setTitleColor(.specialWhite, for: UIControl.State.normal)
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
        button.setTitleColor(UIColor.themePink, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.themePink.cgColor
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
        
        self.view.backgroundColor = .specialWhite
        loginTableView.delegate = self
        loginTableView.dataSource = self
        self.view.addSubview(logoImageView)
        self.view.addSubview(sloganLabel)
        self.view.addSubview(loginTableView)
        self.view.addSubview(stackView)
        
        setUpConstraints()
        addKeyboardObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {NotificationCenter.default.removeObserver(self)}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {self.view.endEditing(true)}
    func setUpConstraints(){
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaHeight_Top + 60).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        sloganLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        sloganLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10).isActive = true
        
        loginTableView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 40).isActive = true
        loginTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loginTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        loginTableView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        stackView.topAnchor.constraint(equalTo: loginTableView.bottomAnchor, constant: 50).isActive = true
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
        let account = getInputValue().account
        let password = getInputValue().password
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "登入中..."
        hud.show(in: self.view, animated: true)
        
        if account.isEmpty || password.isEmpty{
            hud.dismiss(afterDelay: 1)
            Alert.alert_BugReport(message: "尚有欄位未輸入", title: "錯誤", with: self)
        }else{
            Auth.auth().signIn(withEmail: account, password: password) { (result, error) in
                    if let error = error{
                        hud.dismiss(afterDelay: 1)
                        let errorCode = (error as NSError).code
                        self.detectErrorCode(code: errorCode)
                    }else{
                        hud.dismiss(animated: true)
                        UserDefaults.standard.setIsLogIn(value: true)
                        self.dismiss(animated: true, completion: nil)
                    }

                }
        }

    }
    func getInputValue() -> (account: String,password: String){
        let accountIndexPath = IndexPath(row: 0, section: 0)
        let passwordIndexPath = IndexPath(row: 0, section: 1)
        let accountCell = loginTableView.cellForRow(at: accountIndexPath) as! LoginCell
        let passwordCell = loginTableView.cellForRow(at: passwordIndexPath) as! LoginCell
        let account = accountCell.inputTextField.text
        let password = passwordCell.inputTextField.text
        return (account! , password!)
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

extension LoginController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = loginTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LoginCell
        cell.inputTextField.isSecureTextEntry = indexPath.section == 0 ? false : true
        cell.inputTextField.text = indexPath.section == 0 ? "Asiagodtone@q.com" : "Qqqqqq"

        let placeHolder = indexPath.section == 0 ? "輸入帳號..." : "輸入密碼..."
        cell.inputTextField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.themePink])
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
        titleLabel.text = section == 0 ? "帳號" : "密碼"
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
class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.width + 5, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.width + 5, height: bounds.height)
    }
    
}
