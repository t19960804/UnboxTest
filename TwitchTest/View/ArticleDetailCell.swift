//
//  ArticleDetailCell.swift
//  TwitchTest
//
//  Created by t19960804 on 2/7/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation
import UIKit


protocol ArticleDetailCell_Delagate {
    func imageZoomInForStartingImageView(startingImageView: UIImageView)
}
class ArticleDetailCell: UICollectionViewCell {
    
    var delegate: ArticleDetailCell_Delagate?
    var imageURL: String?{
        didSet{
            if let imageURL = imageURL{
                commodityImageView.downLoadImageInCache(downLoadURL: URL(string: imageURL)!)

            }
        }
    }
    let background_commodityImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.shadowGray.cgColor
        view.layer.shadowOpacity = 0.7
        return view
    }()
    lazy var commodityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        //.scaleAspectFill會使圖片充滿imageView,會有一部分被切掉,導致放大縮小時比例不對
//        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageZoom(tapGesture:)))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(background_commodityImageView)
        background_commodityImageView.addSubview(commodityImageView)
        setUpConstraints()
        setUpGradientLayer()
    }
    fileprivate func setUpConstraints() {
        background_commodityImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        background_commodityImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        background_commodityImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.95).isActive = true
        
        
        commodityImageView.topAnchor.constraint(equalTo: background_commodityImageView.topAnchor).isActive = true
        commodityImageView.leftAnchor.constraint(equalTo: background_commodityImageView.leftAnchor).isActive = true
        commodityImageView.rightAnchor.constraint(equalTo: background_commodityImageView.rightAnchor).isActive = true
        commodityImageView.bottomAnchor.constraint(equalTo: background_commodityImageView.bottomAnchor).isActive = true
    }
    
    fileprivate func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        gradientLayer.colors = [UIColor.black.cgColor,UIColor.clear.cgColor]
        commodityImageView.layer.addSublayer(gradientLayer)
    }
    
    @objc func handleImageZoom(tapGesture: UITapGestureRecognizer){
        delegate?.imageZoomInForStartingImageView(startingImageView: commodityImageView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
