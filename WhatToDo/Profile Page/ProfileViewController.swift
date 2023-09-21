//
//  ProfileViewController.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/20.
//

import UIKit
import SnapKit


class ProfileViewController: UIViewController {
    var viewModel: ProfileViewModel!

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "profileImage")
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "Followers: 0"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "Following: 0" 
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    func setupUI() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.skyBlue?.cgColor ?? UIColor.blue.cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(gradient, at: 0)

        self.view.addSubview(profileImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(ageLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(followersLabel)
        self.view.addSubview(followingLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ageLabel.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        followersLabel.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(-40)
        }
        
        followingLabel.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-40)
        }
    }
    
    func populateData() {
        nameLabel.text = viewModel.userName
        ageLabel.text = viewModel.userAge
        descriptionLabel.text = viewModel.description
    }
}

