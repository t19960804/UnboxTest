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
    
    lazy var uploadImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("選擇相片", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleUploadImage), for: .touchUpInside)
        return button
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
        textField.textColor = UIColor.black
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
    let loveImageView_1 = LoveImageView(tintColor: specialWhite)
    let loveImageView_2 = LoveImageView(tintColor: specialWhite)
    let loveImageView_3 = LoveImageView(tintColor: specialWhite)
    let loveImageView_4 = LoveImageView(tintColor: specialWhite)
    let loveImageView_5 = LoveImageView(tintColor: specialWhite)
    
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
        setUpGradient()
        
        
        self.view.backgroundColor = specialWhite
        self.view.addSubview(uploadImageButton)
        self.view.addSubview(titleBackGround)
        self.view.addSubview(titleTextField)
        self.view.addSubview(reviewBackGround)
        self.view.addSubview(reviewTextView)
        self.view.addSubview(heartStackView)
        
        
        setUpNavBar()
        setUpConstraints()
        addTapGesture()
        
//        titleTextField.text = "PLAY ARTS改 Marvel Universe 變體版【X-23】"
//        reviewTextView.text = "「VARIANT PLAY ARTS改 X-23」高約25.4 公分\n戰衣的風格不像狼叔擁有極重的裝甲感，呈現出在緊身衣外再覆蓋鎧甲的輕裝風格\n符合她在漫畫中十分敏捷的形象，腰部還做出了鏤空的設計更凸顯X-23 的身形曲線\n鎧甲有著漂亮的光澤感並刻劃出豐富的細節與紋路，頭雕有戴上頭盔、脫盔兩種樣貌\n除了多個出爪的替換手型外，在腳尖也能裝上鋼爪\n可以變化出多種帥氣的戰鬥姿態！"
        titleTextField.text = "Marvel Universe 變體版【獨眼龍】"
        reviewTextView.text = "Play Arts 改 變體版 獨眼龍」高約27 公分，全身裝備擁有複雜的刻線和鮮豔的配色\n金黃色的盔甲呈現出打磨過的光澤和金屬的厚重質感\n上半身的不對稱造型讓本作更添玩味之處，配件部分包含普通、咬牙兩種版本的頭雕\n還附屬了紅色光束的特效零件以及多個替換手型，可再現獨眼龍發動攻擊的霸氣姿態\n而護目鏡的漸層塗裝也營造出彷彿發光的效果\n獨眼龍帥氣的造型和豐富的細節更是讓人大呼過癮～！"
    }
    func setUpGradient(){
        let gradient = CAGradientLayer()
        let color1 = UIColor(red: 237/255, green: 110/255, blue: 160/255, alpha: 1)
        let color2 = UIColor(red: 236/255, green: 140/255, blue: 105/255, alpha: 1)
        gradient.colors = [color2.cgColor,color1.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.layer.addSublayer(gradient)
    }
    @objc func handleUploadImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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
            loveImageViews[i].tintColor = (i <= number - 1) ? darkHeartColor : specialWhite
        }
    }
    //判斷幾顆愛心
    func numberOfHeart() -> Int{
        
        var count = 0
        for love in loveImageViews{
            if love.tintColor == darkHeartColor{
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
     
        uploadImageButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaHeight_Top + 44 + 18).isActive = true
        uploadImageButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        uploadImageButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -18).isActive = true
        uploadImageButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        
        titleBackGround.topAnchor.constraint(equalTo: uploadImageButton.bottomAnchor, constant: 18).isActive = true
        titleBackGround.leftAnchor.constraint(equalTo: uploadImageButton.leftAnchor).isActive = true
        titleBackGround.rightAnchor.constraint(equalTo: uploadImageButton.rightAnchor).isActive = true
        titleBackGround.heightAnchor.constraint(equalToConstant: 60).isActive = true

        titleTextField.centerYAnchor.constraint(equalTo: titleBackGround.centerYAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: titleBackGround.leftAnchor, constant: 5).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: titleBackGround.heightAnchor, multiplier: 0.75).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: titleBackGround.rightAnchor, constant: -5).isActive = true

        reviewBackGround.topAnchor.constraint(equalTo: titleBackGround.bottomAnchor, constant: 10).isActive = true
        reviewBackGround.leftAnchor.constraint(equalTo: uploadImageButton.leftAnchor).isActive = true
        reviewBackGround.rightAnchor.constraint(equalTo: uploadImageButton.rightAnchor).isActive = true
        reviewBackGround.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        reviewTextView.topAnchor.constraint(equalTo: reviewBackGround.topAnchor, constant: 5).isActive = true
        reviewTextView.leftAnchor.constraint(equalTo: reviewBackGround.leftAnchor, constant: 5).isActive = true
        reviewTextView.rightAnchor.constraint(equalTo: reviewBackGround.rightAnchor, constant: -5).isActive = true
        reviewTextView.bottomAnchor.constraint(equalTo: reviewBackGround.bottomAnchor, constant: -5).isActive = true

        heartStackView.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 8).isActive = true
        heartStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        heartStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        heartStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
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
            if title.isEmpty || review.isEmpty || review == "輸入評論..."{
                return UploadError.NotFillYet.rawValue
            }else if uploadImageButton.currentImage == nil{
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
            let imageRef = Storage.storage().reference().child("ArticleImages").child(imageUID)
            guard let jpgImage = uploadImageButton.currentImage?.jpegData(compressionQuality: 1) else{return}
            imageRef.putData(jpgImage, metadata: nil) { (metadata, error) in
                if let error = error{
                    print("error:",error)
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    if let error = error{
                        print("error:",error)
                        return
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
        guard let category = self.kindOfCategory else{return}

        let values: [String : Any] = [  "category" : category,
                                        "authorUID" : userUID,
                                        "articleUID" : articleUID,
                                        "title" : title,
                                        "imageURL" : downloadURL as Any,
                                        "review" : review,
                                        "numberOfHeart" : "\(numberOfHeart())",
                                        "date" : getTimeStamp()]
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
        uploadImageButton.setImage(getImage, for: .normal)
    }
    //按下取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.textColor == specialGray{
            reviewTextView.text = ""
            reviewTextView.textColor = UIColor.black
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
