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

class PostArticleController: UIViewController {
    
    var kindOfCategory: String?
    lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor.red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChooseImage))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    let titleTextView: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "輸入標題..."
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(uploadImageView)
        self.view.addSubview(titleTextView)
        self.view.backgroundColor = UIColor.white
        setUpNavBar()
        setUpConstraints()
    }
    
    func setUpNavBar(){
        self.navigationItem.title = "發表文章"
        let uploadButtonItem = UIBarButtonItem(title: "上傳", style: .plain, target: self, action: #selector(handleUploadArticle))
        self.navigationItem.rightBarButtonItem = uploadButtonItem
    }
    func setUpConstraints(){
        uploadImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeAreaHeight_Top + 44 + 10).isActive = true
        uploadImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        uploadImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        uploadImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        titleTextView.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 10).isActive = true
        titleTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
    }
    @objc func handleUploadArticle(){
        //先將圖片存進Storage,拿到URL之後,再與其他輸入值一起存進DataBase
        let imageUID = NSUUID().uuidString
        let ref = Storage.storage().reference().child("ArticleImages").child(imageUID)
        guard let jpgImage = uploadImageView.image?.jpegData(compressionQuality: 1) else{return}
        ref.putData(jpgImage, metadata: nil) { (metadata, error) in
            if let error = error{
                print("error:",error)
            }
           
            ref.downloadURL(completion: { (url, error) in
                if let downloadURL = url?.absoluteString{
                    self.addArticleDataToDataBase(downloadURL: downloadURL)
                }
            })
        }
        
    }
    func addArticleDataToDataBase(downloadURL: String){
        let articleUID = NSUUID().uuidString
        //插入"文章"
        guard let title = self.titleTextView.text else{return}
        let values: [String : Any] = ["標題" : title,
                                      "圖片URL" : downloadURL as Any]
        guard let category = self.kindOfCategory else{return}
        let ref = Database.database().reference()
        ref.child("文章").child(articleUID).setValue(values, withCompletionBlock: { (error, ref) in
            if let error = error{
                print("error:",error)
            }
        })
        //插入"類別中的文章"
        ref.child("類別").child(category).child(articleUID).setValue(1)
    }
    @objc func handleChooseImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

//相簿存取
extension PostArticleController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //完成選取
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let getImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        uploadImageView.image = getImage
    }
    //按下取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
