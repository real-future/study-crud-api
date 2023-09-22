//
//  CustomBottomTabBar.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/15.
//

import UIKit

class CustomBottomTabBar: UIView {
    
    let personButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profileIcon"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor(named: "tabBarGrey") 
        self.snp.makeConstraints { make in
            make.height.equalTo(85)
        }
        
        addSubview(personButton)
        
        personButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(18)  
            make.centerX.equalTo(self)
        }
    }
}
