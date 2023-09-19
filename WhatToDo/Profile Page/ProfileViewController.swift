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

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        populateData()
    }
    
    func setupUI() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(ageLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }
    }
    
    func populateData() {
        nameLabel.text = viewModel.userName
        ageLabel.text = viewModel.userAge
    }
}
