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
    let hud = JGProgressHUD(style: .dark)
    let cellID = "Cell"
    let ref = Database.database().reference()
    lazy var uploadImagesColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.2)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(PostArticleCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
    var imageButtonsArray = [UIButton]()
    var downloadURLArray = [String]()
    
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
        textField.attributedPlaceholder = NSAttributedString(string: "輸入標題...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.specialGray])
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
        textView.textColor = .specialGray
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.layer.masksToBounds = true
        return textView
    }()
    let loveImageView_1 = LoveImageView(tintColor: .specialWhite)
    let loveImageView_2 = LoveImageView(tintColor: .specialWhite)
    let loveImageView_3 = LoveImageView(tintColor: .specialWhite)
    let loveImageView_4 = LoveImageView(tintColor: .specialWhite)
    let loveImageView_5 = LoveImageView(tintColor: .specialWhite)
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
        uploadImagesColletionView.delegate = self
        uploadImagesColletionView.dataSource = self
        
        self.view.backgroundColor = .specialWhite
        
        
        self.view.addSubview(titleBackGround)
        self.view.addSubview(titleTextField)
        self.view.addSubview(reviewBackGround)
        self.view.addSubview(reviewTextView)
        self.view.addSubview(heartStackView)
        self.view.addSubview(uploadImagesColletionView)
        
        setUpNavBar()
        setUpConstraints()
        addTapGesture()
        
        titleTextField.text = "《地獄犬的輓歌》文森特·瓦倫汀"
        reviewTextView.text = "「PLAY ARTS改 文森特·瓦倫汀」紅色披風的造型銳利，在施以強烈的陰影漸層後更是中二度滿點\n披風與頭髮皆設置了可動機構，能隨著帥氣的動作擺動！相較於過去可動滿悲劇的AC版\n這次算進步滿多的。配件則收錄了兩把愛槍「地獄犬（Cerberus）」、「九頭蛇（Hydra）」，地獄犬可收納於右腿的槍套。"
    }
    func setUpGradient(){
        let gradient = CAGradientLayer()
        let color1 = UIColor(red: 237/255, green: 110/255, blue: 160/255, alpha: 1)
        let color2 = UIColor(red: 236/255, green: 140/255, blue: 105/255, alpha: 1)
        gradient.colors = [color2.cgColor,color1.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.layer.addSublayer(gradient)
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
    @objc func handleHeartPressed_1(){pressHeart(number: 1)}
    @objc func handleHeartPressed_2(){pressHeart(number: 2)}
    @objc func handleHeartPressed_3(){pressHeart(number: 3)}
    @objc func handleHeartPressed_4(){pressHeart(number: 4)}
    @objc func handleHeartPressed_5(){pressHeart(number: 5)}
    //點擊愛心變色
    func pressHeart(number: Int){
        for i in 0...loveImageViews.count - 1{
            loveImageViews[i].tintColor = (i <= number - 1) ? .darkHeartColor : .specialWhite
        }
    }
    //判斷幾顆愛心
    func numberOfHeart() -> Int{
        var count = 0
        for love in loveImageViews{
            if love.tintColor == .darkHeartColor{
                count += 1
            }
        }
        return count
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {self.view.endEditing(true)}
    func setUpNavBar(){
        self.navigationItem.title = "發表文章"
        let uploadButtonItem = UIBarButtonItem(title: "上傳", style: .plain, target: self, action: #selector(alertWhenPostArticle))
        self.navigationItem.rightBarButtonItem = uploadButtonItem
    }
    func setUpConstraints(){

        uploadImagesColletionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaHeight_Top + 44 + 18).isActive = true
        uploadImagesColletionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadImagesColletionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        uploadImagesColletionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        


        titleBackGround.topAnchor.constraint(equalTo: uploadImagesColletionView.bottomAnchor, constant: 18).isActive = true
        titleBackGround.leftAnchor.constraint(equalTo: uploadImagesColletionView.leftAnchor,constant: 18).isActive = true
        titleBackGround.rightAnchor.constraint(equalTo: uploadImagesColletionView.rightAnchor,constant: -18).isActive = true
        titleBackGround.heightAnchor.constraint(equalToConstant: 60).isActive = true

        titleTextField.centerYAnchor.constraint(equalTo: titleBackGround.centerYAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: titleBackGround.leftAnchor, constant: 5).isActive = true
        titleTextField.heightAnchor.constraint(equalTo: titleBackGround.heightAnchor, multiplier: 0.75).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: titleBackGround.rightAnchor, constant: -5).isActive = true

        reviewBackGround.topAnchor.constraint(equalTo: titleBackGround.bottomAnchor, constant: 10).isActive = true
        reviewBackGround.leftAnchor.constraint(equalTo: titleBackGround.leftAnchor).isActive = true
        reviewBackGround.rightAnchor.constraint(equalTo: titleBackGround.rightAnchor).isActive = true
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

    func whatKindOfError() throws{
        if let title = titleTextField.text,let review = reviewTextView.text{
            if title.isEmpty || review.isEmpty || review == "輸入評論..."{
                throw UploadError.NotFillYet
            }else if imageViewsIsEmpty(array: imageButtonsArray){
                throw UploadError.NoImage
            }else if numberOfHeart() == 0{
                throw UploadError.NoEvaluate
            }
        }
    }
    func imageViewsIsEmpty(array: [UIButton]) -> Bool{
        if array.count != 3{
            return true
        }else{
            for button in array{
                if button.currentImage == nil{
                    return true
                }
            }
        }
        
        return false
    }
    
    func handleUploadArticle(){
        do{
            try whatKindOfError()
        }catch UploadError.NotFillYet{
            Alert.alert_BugReport(message: "尚有欄位未輸入", title: "錯誤", with: self)
            return
        }catch UploadError.NoImage{
            Alert.alert_BugReport(message: "請選擇照片", title: "錯誤", with: self)
            return
        }catch UploadError.NoEvaluate{
            Alert.alert_BugReport(message: "請給予評價", title: "錯誤", with: self)
            return
        }catch{
            Alert.alert_BugReport(message: "不明錯誤", title: "錯誤", with: self)
            return
        }
        hud.textLabel.text = "上傳中"
        hud.show(in: self.view, animated: true)
        let imagesDataArray = compressImageToData(array: imageButtonsArray)
        for image in imagesDataArray{
            putDataToStorage(data: image) { (urlArray) in
                if urlArray.count == 3{
                    self.addArticleDataToDataBase(array: urlArray)
                }
            }
        }
    }
    func compressImageToData(array: [UIButton]) -> [Data]{
        var imagesDataArray = [Data]()
        for button in array{
            if let jpgImage = button.currentImage?.jpegData(compressionQuality: 1){
                imagesDataArray.append(jpgImage)
            }
        }
        return imagesDataArray
    }
    func putDataToStorage(data: Data,completion: @escaping ([String]) -> Void){
        let imageUID = NSUUID().uuidString
        let imageRef = Storage.storage().reference().child("ArticleImages").child(imageUID)
        imageRef.putData(data, metadata: nil) { (metadata, error) in
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
                self.downloadURLArray.append(downloadURL)
                completion(self.downloadURLArray)
            })
            
        }
    }
    func addArticleDataToDataBase(array: [String]){
        let articleUID = NSUUID().uuidString
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        guard let title = self.titleTextField.text else{return}
        guard let review = self.reviewTextView.text else{return}
        guard let category = self.kindOfCategory else{return}
        let values: [String : Any] = [  "category" : category,
                                        "authorUID" : userUID,
                                        "articleUID" : articleUID,
                                        "title" : title,
                                        "imageURL" : array,
                                        "review" : review,
                                        "numberOfHeart" : "\(numberOfHeart())",
                                        "date" : getTimeStamp()]
        
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

//MARK: - 相簿存取 + TextView的PlaceHolder處理
extension PostArticleController: UITextViewDelegate{
 
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.textColor == .specialGray{
            reviewTextView.text = ""
            reviewTextView.textColor = UIColor.black
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextView.text.isEmpty{
            reviewTextView.textColor = .specialGray
            reviewTextView.text = "輸入評論..."
        }
        
    }
}
//MARK: - ColltionView處理
extension PostArticleController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.uploadImagesColletionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PostArticleCell
        if imageButtonsArray.count >= 3{
            imageButtonsArray.remove(at: indexPath.row)
        }
        imageButtonsArray.append(cell.uploadImageButton)
        cell.delegate = self
        return cell
    }
    
    
}
extension PostArticleController: PostArticleCell_Delegate{
    func openAlbum(cell: UICollectionViewCell) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = cell as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(picker, animated: true, completion: nil)
    }
}

enum UploadError: Error{
    case NotFillYet
    case NoImage
    case NoEvaluate
}
