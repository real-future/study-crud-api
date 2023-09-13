//
//  HomePageViewController.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/13.
//

import UIKit
import SnapKit

class HomePageViewController: UIViewController {
    
    lazy var topBoxView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
        
    }()
    
    lazy var spartaLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "spartaLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WhatToDo"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .skyBlue
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Spartacodingclub Homework"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .skyBlue
        return label
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setupConstraints()
    }
    
    private func setupUI() {
        //뷰의 배경
        self.view.backgroundColor = .skyBlue
        
        self.view.addSubview(topBoxView)
        topBoxView.addSubview(spartaLogoImageView)
        topBoxView.addSubview(titleLabel)
        topBoxView.addSubview(subTitleLabel)
        self.view.addSubview(buttonStackView)
        
        setButtonCell()
    }
    
    
    func setButtonCell() {
        let buttonTitles = ["Todo", "Done Tasks", "My Gallery", "Cat"]
        
        for title in buttonTitles {
            let buttonCellView = createButtonCell(withTitle: title)
            buttonStackView.addArrangedSubview(buttonCellView)
        }
    }
    
    
    private func createButtonCell(withTitle title: String) -> UIView {
        let buttonCellView = UIView()
        buttonCellView.backgroundColor = .skyBlue
        
        let buttonTitleLabel = UILabel()
        buttonTitleLabel.text = title
        buttonTitleLabel.font = UIFont.systemFont(ofSize: 30)
        buttonTitleLabel.textColor = .white
        
        let arrowIconImageView = UIImageView()
            arrowIconImageView.image = UIImage(systemName: "chevron.right")
            arrowIconImageView.tintColor = .white
            arrowIconImageView.contentMode = .scaleAspectFit
        
        buttonCellView.addSubview(buttonTitleLabel)
        buttonCellView.addSubview(arrowIconImageView)
        
        buttonTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(buttonCellView.snp.left).offset(20)
            make.centerY.equalTo(buttonCellView.snp.centerY)
        }
        
        arrowIconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(buttonCellView.snp.right).offset(-20)
            make.centerY.equalTo(buttonCellView.snp.centerY)
        }
        
        return buttonCellView
    }
    
    private func setupConstraints() {
        topBoxView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.47)
        }
        
        spartaLogoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(100)
            make.right.equalTo(topBoxView.snp.right).offset(-20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(spartaLogoImageView.snp.bottom).offset(10)
            make.right.equalTo(topBoxView.snp.right).offset(-20)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalTo(topBoxView.snp.right).offset(-20)
        }
        
        buttonStackView.snp.makeConstraints { (make) in
            make.top.equalTo(topBoxView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.53).offset(-20)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }
    
    
}
