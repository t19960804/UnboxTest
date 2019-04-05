//
//  LoginController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/9/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginController: UIViewController {
    
    
    
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
        tableView.backgroundColor = .specialWhite
        tableView.delegate = self
        tableView.dataSource = self
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
    
    var accountCell: AccountCell?
    var passwordCell: PasswordCell?
    let loginHUD = JGProgressHUD(style: .dark)
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .specialWhite
        setUpConstraints()
        addKeyboardObserver()
        setUpViewModelObserver()
    }
    override func viewDidAppear(_ animated: Bool) { addTextFieldTarget() }
    override func viewWillDisappear(_ animated: Bool) { NotificationCenter.default.removeObserver(self) }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true) }
    fileprivate func setUpConstraints(){
        self.view.addSubview(logoImageView)
        self.view.addSubview(sloganLabel)
        self.view.addSubview(loginTableView)
        self.view.addSubview(stackView)
        
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
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
    
    fileprivate func addKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    fileprivate func setUpViewModelObserver(){
        loginViewModel.isLoginingObserver = { [weak self] (isLogining) in
            guard let isLogining = isLogining else{ return }
            if isLogining{
                self?.showLoginHUD()
            }else{
                self?.loginHUD.dismiss(animated: true)
            }
            
        }
    }
    fileprivate func showLoginHUD(){
        loginHUD.textLabel.text = "登入中"
        loginHUD.detailTextLabel.text = "請稍候"
        loginHUD.show(in: self.view, animated: true)
    }
    fileprivate func showErrorHUD(detail: String){
        let errorHUD = JGProgressHUD(style: .dark)
        errorHUD.textLabel.text = "錯誤"
        errorHUD.detailTextLabel.text = detail
        errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
        errorHUD.show(in: self.view, animated: true)
        errorHUD.dismiss(afterDelay: 3, animated: true)
    }
    //MARK: - Selector方法
    @objc func handleLogin(){
        self.view.endEditing(true)
        loginViewModel.isLogining = true
        loginViewModel.performLogin { [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .failure(let error):
                self.loginViewModel.isLogining = false
                self.showErrorHUD(detail: error.localizedDescription)
            case .success(let message):
                self.loginViewModel.isLogining = false
                self.dismiss(animated: true, completion: nil)
                print(message)
            }
        }
    }
    fileprivate func  addTextFieldTarget(){
        let accountIndexPath = IndexPath(row: 0, section: 0)
        let passwordIndexPath = IndexPath(row: 0, section: 1)
        
        accountCell = loginTableView.cellForRow(at: accountIndexPath) as? AccountCell
        passwordCell = loginTableView.cellForRow(at: passwordIndexPath) as? PasswordCell
        
        accountCell?.inputTextField.addTarget(self, action: #selector(handleInputChanged(textField:)), for: .editingChanged)
        passwordCell?.inputTextField.addTarget(self, action: #selector(handleInputChanged(textField:)), for: .editingChanged)
        
    }
    @objc fileprivate func handleInputChanged(textField: UITextField){
        if textField == accountCell?.inputTextField{
            loginViewModel.account = textField.text
        }else{
            loginViewModel.password = textField.text
        }
    }
    
    @objc func handleRegister(){self.present(RegisterController(), animated: true, completion: nil)}
    @objc func handleKeyboardShow(_ notification: Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let bottomSpace = self.view.frame.height - stackView.frame.origin.y - stackView.frame.height
            let difference = keyboardHeight - bottomSpace
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -difference + 10)
            })
            
        }
    }
    @objc func handleKeyboardHide(_ notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform.identity
        })
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
        let cell: UITableViewCell
        if indexPath.section == 0{
            cell = AccountCell(style: .default, reuseIdentifier: nil)
        }else{
            cell = PasswordCell(style: .default, reuseIdentifier: nil)
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
        titleLabel.font = .boldSystemFont(ofSize: 18)
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

