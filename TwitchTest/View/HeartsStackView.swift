//
//  HeartsStackView.swift
//  TwitchTest
//
//  Created by t19960804 on 3/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class HeartsStackView: UIStackView {
    var loveImageViews = [UIImageView]()
    let loveImageView_1 = LoveImageView(tintColor: .specialWhite)
    let loveImageView_2 = LoveImageView(tintColor: .specialWhite)
    let loveImageView_3 = LoveImageView(tintColor: .specialWhite)
    let loveImageView_4 = LoveImageView(tintColor: .specialWhite)
    let loveImageView_5 = LoveImageView(tintColor: .specialWhite)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(loveImageView_1)
        self.addArrangedSubview(loveImageView_2)
        self.addArrangedSubview(loveImageView_3)
        self.addArrangedSubview(loveImageView_4)
        self.addArrangedSubview(loveImageView_5)
        self.distribution = .fillEqually
        self.axis = .horizontal
        self.spacing = 7
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
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
