//
//  PostArticleController.swift
//  TwitchTest
//
//  Created by t19960804 on 1/13/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import JGProgressHUD

class PostArticleController: UIViewController {
    var loveImageViews = [UIImageView]()
    var kindOfCategory: String?
    let hud = JGProgressHUD(style: .light)
    
    let viewBackGround: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = specialGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChooseImage))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    let titleBackGround: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let titleTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = themeGrayColor
        textField.attributedPlaceholder = NSAttributedString(string: "輸入標題...", attributes: [NSAttributedString.Key.foregroundColor : specialGray])
        return textField
    }()
    let reviewBackGround: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.white
        textView.text = "輸入評論..."
        textView.textColor = specialGray
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.layer.masksToBounds = true
        return textView
    }()
    let loveImageView_1 = LoveImageView(tintColor: themeGrayColor)
    let loveImageView_2 = LoveImageView(tintColor: themeGrayColor)
    let loveImageView_3 = LoveImageView(tintColor: themeGrayColor)
    let loveImageView_4 = LoveImageView(tintColor: themeGrayColor)
    let loveImageView_5 = LoveImageView(tintColor: themeGrayColor)
    
    lazy var heartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(loveImageView_1)
        stackView.addArrangedSubview(loveImageView_2)
        stackView.addArrangedSubview(loveImageView_3)
        stackView.addArrangedSubview(loveImageView_4)
        stackView.addArrangedSubview(loveImageView_5)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 7
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.delegate = self
        self.view.backgroundColor = themeGrayColor
        self.view.addSubview(viewBackGround)
        self.view.addSubview(uploadImageView)
        self.view.addSubview(titleBackGround)
        self.view.addSubview(titleTextField)
        self.view.addSubview(reviewBackGround)
        self.view.addSubview(reviewTextView)
        self.view.addSubview(heartStackView)
        setUpNavBar()
        setUpConstraints()
        addTapGesture()
    }
    func addTapGesture(){
        
        loveImageViews.append(loveImageView_1)
        loveImageViews.append(loveImageView_2)
        loveImageViews.append(loveImageView_3)
        loveImageViews.append(loveImageView_4)
        loveImageViews.append(loveImageView_5)
        
        let tap_1 = UITapGestureRecognizer(target: self, action: #selector(handleHeartPressed_1))
        let tap_2 = UITapGestureRecognizer(target: self, action: #selector(handleHeartPressed_2))
        let tap_3 = UITapGestureRecognizer(target: self, action: #selector(handleHeartPressed_3))
        let tap_4 = UITapGestureRecognizer(target: self, action: #selector(handleHeartPressed_4))
        let tap_5 = UITapGestureRecognizer(target: self, action: #selector(handleHeartPressed_5))
        
        loveImageView_1.addGestureRecognizer(tap_1)
        loveImageView_2.addGestureRecognizer(tap_2)
        loveImageView_3.addGestureRecognizer(tap_3)
        loveImageView_4.addGestureRecognizer(tap_4)
        loveImageView_5.addGestureRecognizer(tap_5)
        
    }
    //
    @objc func handleHeartPressed_1(){
        pressHeart(number: 1)
    }
    @objc func handleHeartPressed_2(){
        pressHeart(number: 2)
    }
    @objc func handleHeartPressed_3(){
        pressHeart(number: 3)
    }
    @objc func handleHeartPressed_4(){
        pressHeart(number: 4)
    }
    @objc func handleHeartPressed_5(){
        pressHeart(number: 5)
    }
    //點擊愛心變色
    func pressHeart(number: Int){
        for i in 0...loveImageViews.count - 1{
            loveImageViews[i].tintColor = (i <= number - 1) ? specialYellow : themeGrayColor
        }
    }
    //判斷幾顆愛心
    func numberOfHeart() -> Int{
        
        var count = 0
        for love in loveImageViews{
            if love.tintColor == specialYellow{
                count += 1
            }
        }
        return count
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func setUpNavBar(){
        self.navigationItem.title = "發表文章"
        let uploadButtonItem = UIBarButtonItem(title: "上傳", style: .plain, target: self, action: #selector(alertWhenPostArticle))
        self.navigationItem.rightBarButtonItem = uploadButtonItem
    }
    func setUpConstraints(){
        
        viewBackGround.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaHeight_Top + 44 + 10).isActive = true
        viewBackGround.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        viewBackGround.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        viewBackGround.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(safeAreaHeight_Bottom)).isActive = true
        
        
        uploadImageView.topAnchor.constraint(equalTo: viewBackGround.topAnchor, constant: 8).isActive = true
        uploadImageView.leftAnchor.constraint(equalTo: viewBackGround.leftAnchor, constant: 8).isActive = true
        uploadImageView.rightAnchor.constraint(equalTo: viewBackGround.rightAnchor, constant: -8).isActive = true
        uploadImageView.heightAnchor.constraint(equalTo: viewBackGround.heightAnchor, multiplier: 0.25).isActive = true
        
        titleBackGround.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 18).isActive = true
        titleBackGround.leftAnchor.constraint(equalTo: uploadImageView.leftAnchor).isActive = true
        titleBackGround.rightAnchor.constraint(equalTo: uploadImageView.rightAnchor).isActive = true
        titleBackGround.heightAnchor.constraint(equalToConstant: 60).isActive = true

        titleTextField.centerYAnchor.constraint(equalTo: titleBackGround.centerYAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: titleBackGround.leftAnchor, constant: 5).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: titleBackGround.heightAnchor, multiplier: 0.75).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: titleBackGround.rightAnchor, constant: -5).isActive = true

        reviewBackGround.topAnchor.constraint(equalTo: titleBackGround.bottomAnchor, constant: 10).isActive = true
        reviewBackGround.leftAnchor.constraint(equalTo: uploadImageView.leftAnchor).isActive = true
        reviewBackGround.rightAnchor.constraint(equalTo: uploadImageView.rightAnchor).isActive = true
        reviewBackGround.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        reviewTextView.topAnchor.constraint(equalTo: reviewBackGround.topAnchor, constant: 5).isActive = true
        reviewTextView.leftAnchor.constraint(equalTo: reviewBackGround.leftAnchor, constant: 5).isActive = true
        reviewTextView.rightAnchor.constraint(equalTo: reviewBackGround.rightAnchor, constant: -5).isActive = true
        reviewTextView.bottomAnchor.constraint(equalTo: reviewBackGround.bottomAnchor, constant: -5).isActive = true

        heartStackView.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 8).isActive = true
        heartStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        heartStackView.widthAnchor.constraint(equalTo: viewBackGround.widthAnchor, multiplier: 0.7).isActive = true
        heartStackView.bottomAnchor.constraint(equalTo: viewBackGround.bottomAnchor, constant: -8).isActive = true
    }
    
    @objc func alertWhenPostArticle(){
        let alert = UIAlertController(title: "提示", message: "確定上傳?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "確定", style: .default) { (action) in
            self.handleUploadArticle()
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancleAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    func whatKindOfError() -> String?{
        if let title = titleTextField.text,let review = reviewTextView.text{
            if title.isEmpty || review.isEmpty{
                return UploadError.NotFillYet.rawValue
            }else if uploadImageView.image == nil{
                return UploadError.NoImage.rawValue
            }else if numberOfHeart() == 0{
                return UploadError.NoEvaluate.rawValue
            }else{
                return nil
            }
        }
        return nil
    }
    func handleUploadArticle(){
        let error = whatKindOfError()
        switch error {
        case UploadError.NotFillYet.rawValue:
            Alert.alert_BugReport(message: "尚有欄位未輸入", title: "錯誤", with: self)
        case UploadError.NoImage.rawValue:
            Alert.alert_BugReport(message: "請選擇照片", title: "錯誤", with: self)
        case UploadError.NoEvaluate.rawValue:
            Alert.alert_BugReport(message: "請給予評價", title: "錯誤", with: self)
        default:
            hud.textLabel.text = "上傳中"
            hud.show(in: self.view, animated: true)
            //先將圖片存進Storage,拿到URL之後,再與其他輸入值一起存進DataBase
            let imageUID = NSUUID().uuidString
            let ref = Storage.storage().reference().child("ArticleImages").child(imageUID)
            guard let jpgImage = uploadImageView.image?.jpegData(compressionQuality: 1) else{return}
            ref.putData(jpgImage, metadata: nil) { (metadata, error) in
                if let error = error{
                    print("error:",error)
                }
                ref.downloadURL(completion: { (url, error) in
                    if let error = error{
                        print("error:",error)
                    }
                    guard let downloadURL = url?.absoluteString else{return}
                    self.addArticleDataToDataBase(downloadURL: downloadURL)
                    
                })
            }
        }

        
       
        
    }
    func addArticleDataToDataBase(downloadURL: String){
        let articleUID = NSUUID().uuidString
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        guard let title = self.titleTextField.text else{return}
        guard let review = self.reviewTextView.text else{return}
        let values: [String : Any] = [  "authorUID" : userUID,
                                        "title" : title,
                                        "imageURL" : downloadURL as Any,
                                        "review" : review,
                                        "numberOfHeart" : "\(numberOfHeart())",
                                        "date" : getTimeStamp()]
        guard let category = self.kindOfCategory else{return}
        let ref = Database.database().reference()
        //插入"文章"
        ref.child("文章").child(articleUID).setValue(values, withCompletionBlock: { (error, ref) in
            if let error = error{
                print("error:",error)
                return
            }
        })
        //插入"類別中的文章"
        ref.child("類別").child(category).child(articleUID).setValue(1) { (error, ref) in
            if let error = error{
                print("error:",error)
                return
            }
            self.hud.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        //插入"使用者-文章"
        ref.child("使用者-文章").child(userUID).child(articleUID).setValue(1) { (error, ref) in
            if let error = error{
                print("error:",error)
                return
            }
        }
        //先取得當前使用者的文章數量,成功上傳時將它+1,更新到使用者的資料中
        let userRef = ref.child("使用者").child(userUID)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let dictionary = snapshot.value as! [String : Any]
            if let numbersOfArticleNow = dictionary["numbersOfArticle"] as? Int{
                userRef.updateChildValues(["numbersOfArticle" : numbersOfArticleNow + 1]) { (error, ref) in
                    if let error = error{
                        print("error:",error)
                        return
                    }
                }
            }
        }
        
        
    }
    @objc func handleChooseImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    //取得時間
    func getTimeStamp() -> String{
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let dateNow = dateFormat.string(from: date)
        return dateNow
    }
}

//相簿存取 + TextView的PlaceHolder處理
extension PostArticleController: UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{
    //完成選取
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let getImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        uploadImageView.image = getImage
    }
    //按下取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.textColor == specialGray{
            reviewTextView.text = ""
            reviewTextView.textColor = themeGrayColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextView.text.isEmpty{
            reviewTextView.textColor = specialGray
            reviewTextView.text = "輸入評論..."
        }
        
    }
}

enum UploadError: String{
    case NotFillYet
    case NoImage
    case NoEvaluate
}
