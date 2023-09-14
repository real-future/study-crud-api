//
//  MyGalleryPageViewController.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/14.
//

import UIKit

enum TabIndex {
    case first
    case second
    case third
}


class MyGalleryPageViewController: UIViewController, CustomTabBarDelegate {
    func didSelectTab(at index: TabIndex) {
        changeActiveTab(to: index)

    }
   
    
    
    let profileImage = UIImage(named: "menuIcon")
    var tabIndex: TabIndex = .first
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "르탄이"
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer🍎"
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.numberOfLines = 3
        return label
    }()
    
    lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "spartacodingclub.kr"
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.textColor = .urlBlue
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, websiteLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .skyBlue
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Message", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.lightGrey?.cgColor
        return button
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.lightGrey?.cgColor
        return button
    }()
    
    
    lazy var followMessageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followButton, messageButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .moreLightGrey
        return view
    }()
    
    lazy var customTabBar: CustomTabBar = {
        let tabBar = CustomTabBar()
        return tabBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    
    
    
    
    
    func createLabelStack(number: String, text: String) -> UIStackView {
        let numberLabel = UILabel()
        numberLabel.text = number
        numberLabel.font = UIFont.boldSystemFont(ofSize: 18)
        numberLabel.textColor = .black
        numberLabel.textAlignment = .center
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textColor = .black
        textLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [numberLabel, textLabel])
        stack.axis = .vertical
        stack.spacing = 0
        
        numberLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        
        textLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
        }
        
        
        return stack
    }
    
    func changeActiveTab(to newTab: TabIndex) {
           self.tabIndex = newTab
           self.collectionView.reloadData()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabBar.delegate = self
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "nabaecamp"
        let menuButton = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: .plain, target: self, action: #selector(menuButtonTapped))
        menuButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = menuButton
        
        setupProfileSection()
    }
    
    
    @objc func menuButtonTapped() {
        print("Menu button tapped")
    }
    
    @objc func openWebsite() {
        if let url = URL(string: "http://spartacodingclub.kr") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    

    
    func setupProfileSection() {
        let postStack = createLabelStack(number: "7", text: "Post")
        let followerStack = createLabelStack(number: "0", text: "Follower")
        let followingStack = createLabelStack(number: "0", text: "Following")
        
        let labelsStack = UIStackView(arrangedSubviews: [postStack, followerStack, followingStack])
        labelsStack.axis = .horizontal
        labelsStack.alignment = .fill
        labelsStack.distribution = .fillEqually
        labelsStack.spacing = 16
        
        view.addSubview(profileImageView)
        view.addSubview(labelsStack)
        view.addSubview(infoStackView)
        view.addSubview(followMessageStackView)
        view.addSubview(moreButton)
        view.addSubview(dividerView)
        view.addSubview(customTabBar)
        view.addSubview(collectionView)
        
        
        
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(14)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            make.width.height.equalTo(100)
        }
        
        labelsStack.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-28)
            make.centerY.equalTo(profileImageView)
        }
        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(14)
            make.left.equalTo(profileImageView)
            make.right.lessThanOrEqualTo(labelsStack)
        }
        
        followMessageStackView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(infoStackView.snp.bottom).offset(14)
            make.left.equalTo(profileImageView)
            make.right.lessThanOrEqualTo(moreButton.snp.left).offset(-8)
        }
        
        moreButton.snp.makeConstraints { make in
            make.left.equalTo(followMessageStackView.snp.right).offset(8)
            make.right.equalTo(view.snp.right).offset(-14)
            make.width.height.equalTo(30)
            make.centerY.equalTo(followMessageStackView)
        }
        
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(followMessageStackView.snp.width).multipliedBy(0.5).offset(-4)
        }
        
        messageButton.snp.makeConstraints { make in
            make.width.equalTo(followMessageStackView.snp.width).multipliedBy(0.5).offset(-4)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(followMessageStackView.snp.bottom).offset(10)
            make.left.equalTo(profileImageView)
            make.right.equalTo(moreButton.snp.right)
            make.height.equalTo(1)
        }

        
        customTabBar.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(35)
            make.top.equalTo(dividerView.snp.bottom).offset(2)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(customTabBar.snp.bottom)
        }
    }
}

extension MyGalleryPageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tabIndex {
                case .first:
                    return 9
                case .second:
                    return 9
                case .third:
                    return 9
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        switch tabIndex {
                case .first:
                    cell.backgroundColor = .green
                case .second:
                    cell.backgroundColor = .red
                case .third:
                    cell.backgroundColor = .yellow
                }

                return cell
            }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 4) / 3
        return CGSize(width: width, height: width)
    }
}

// MARK: - ddfdf
extension MyGalleryPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tabIndex == .first && indexPath.item == 1 {
            changeActiveTab(to: .second)
        } else if tabIndex == .first && indexPath.item == 2 {
            changeActiveTab(to: .third)
        }
    }
}
