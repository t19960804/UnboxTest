//
//  PostArticleCell.swift
//  TwitchTest
//
//  Created by t19960804 on 2/6/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit

protocol PostArticleCell_Delegate {
    func openAlbum(cell: UICollectionViewCell)
}

class PostArticleCell: UICollectionViewCell {
    var delegate: PostArticleCell_Delegate?
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
    override init(frame: CGRect) {
        super.init(frame: .zero)

        self.addSubview(uploadImageButton)
        setUpConstraints()
    }
    func setUpConstraints(){
        uploadImageButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 18).isActive = true
        uploadImageButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        uploadImageButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18).isActive = true
        uploadImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    @objc func handleUploadImage(){
        delegate?.openAlbum(cell: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 相簿存取 + TextView的PlaceHolder處理
extension PostArticleCell: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
 
}
