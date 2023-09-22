//
//  MyGalleryPageViewController.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/14.
//


import UIKit

//MARK: - enum
enum TabIndex {
    case first
    case second
    case third
}


class MyGalleryPageViewController: UIViewController {
    
    
    // MARK: - Properties
    let profileImage = UIImage(named: "profileImage")
    var tabIndex: TabIndex = .first
    var images: [UIImage] = []
    
    
    // MARK: - UI Components
    // MARK: - UI Components_Navigation Bar
    private let customNavigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "nabaecamp"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.skyBlue, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menuIcon"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - UI Components_Profile
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var labelsStack: UIStackView = {
        let postStack = createLabelStack(number: "7", text: "Post")
        let followerStack = createLabelStack(number: "0", text: "Follower")
        let followingStack = createLabelStack(number: "0", text: "Following")
        
        let stack = UIStackView(arrangedSubviews: [postStack, followerStack, followingStack])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        return stack
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "르탄이"
        label.font = UIFont(name: "OpenSans-Bold", size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer🍎"
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.numberOfLines = 3
        return label
    }()
    
    
    private let websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "spartacodingclub.kr"
        label.font = UIFont(name: "OpenSans-Regular", size: 14)
        label.textColor = .urlBlue
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: MyGalleryPageViewController.self, action: #selector(openWebsite))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, websiteLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    
    // MARK: - UI Components_Follow & Message
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .skyBlue
        button.layer.cornerRadius = 4
        return button
    }()
    
    
    private let messageButton: UIButton = {
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
    
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.lightGrey?.cgColor
        return button
    }()
    
    
    private lazy var followMessageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followButton, messageButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    
    // MARK: - UI Components_dividerView
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .moreLightGrey
        return view
    }()
    
    
    // MARK: - UI Components_CustomBar
    private let customTabBar: CustomTabBar = {
        let tabBar = CustomTabBar()
        return tabBar
    }()
    
    
    // MARK: - UI Components_collectionView
    private lazy var collectionView: UICollectionView = {
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
    
    
    // MARK: - UI Components_customBottomTabBar
    private let customBottomTabBar: CustomBottomTabBar = {
        let tabBar = CustomBottomTabBar()
        return tabBar
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
    
    
    // MARK: - Actions
    @objc func menuButtonTapped() {
        print("Menu button tapped")
    }
    
    
    @objc func openWebsite() {
        if let url = URL(string: "http://spartacodingclub.kr") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @objc func profileImageViewTapped() {
        let profileModel = ProfileModel(userName: "르탄이", userAge: 26, description: "iOS Developer🍎")
        let profileViewModel = ProfileViewModel(profile: profileModel)
        let profileViewController = ProfileViewController()
        profileViewController.viewModel = profileViewModel
        profileViewController.modalPresentationStyle = .automatic
        self.present(profileViewController, animated: true, completion: nil)
    }
    
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func presentImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func setupGestureForProfileImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func changeActiveTab(to newTab: TabIndex) {
        self.tabIndex = newTab
        self.collectionView.reloadData()
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabBar.delegate = self
        setupUI()
    }
    
    
    //MARK: - setupUI
    func setupUI() {
        self.view.backgroundColor = .white
        setupGestureForProfileImageView()
        setupConstraints()
    }
    
    
    func setupConstraints() {
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 85, right: 0)
        
        let postStack = createLabelStack(number: "7", text: "Post")
        let followerStack = createLabelStack(number: "0", text: "Follower")
        let followingStack = createLabelStack(number: "0", text: "Following")
        
        let labelsStack = UIStackView(arrangedSubviews: [postStack, followerStack, followingStack])
        labelsStack.axis = .horizontal
        labelsStack.alignment = .fill
        labelsStack.distribution = .fillEqually
        labelsStack.spacing = 16
        
        view.addSubview(customNavigationBar)
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
            make.height.equalTo(44)  // 네비게이션 바 높이
        }
        
        customNavigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(customNavigationBar)
            make.centerY.equalTo(customNavigationBar)
        }
        
        customNavigationBar.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.left.equalTo(customNavigationBar.snp.left).offset(16)
            make.centerY.equalTo(customNavigationBar)
        }
        
        customNavigationBar.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.right.equalTo(customNavigationBar.snp.right).offset(-16)
            make.centerY.equalTo(customNavigationBar)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(labelsStack)
        labelsStack.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-28)
            make.centerY.equalTo(profileImageView)
        }
        
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(14)
            make.left.equalTo(profileImageView)
            make.right.lessThanOrEqualTo(labelsStack)
        }
        
        view.addSubview(followMessageStackView)
        followMessageStackView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(infoStackView.snp.bottom).offset(14)
            make.left.equalTo(profileImageView)
            make.right.lessThanOrEqualTo(moreButton.snp.left).offset(-8)
        }
        
        followButton.snp.makeConstraints { make in
            make.width.equalTo(followMessageStackView.snp.width).multipliedBy(0.5).offset(-4)
        }
        
        messageButton.snp.makeConstraints { make in
            make.width.equalTo(followMessageStackView.snp.width).multipliedBy(0.5).offset(-4)
        }
        
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.left.equalTo(followMessageStackView.snp.right).offset(8)
            make.right.equalTo(view.snp.right).offset(-14)
            make.width.height.equalTo(30)
            make.centerY.equalTo(followMessageStackView)
        }
        
        view.addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(followMessageStackView.snp.bottom).offset(10)
            make.left.equalTo(profileImageView)
            make.right.equalTo(moreButton.snp.right)
            make.height.equalTo(1)
        }
        
        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(35)
            make.top.equalTo(dividerView.snp.bottom).offset(2)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(customTabBar.snp.bottom)
        }
        
        
        view.addSubview(customBottomTabBar)
        customBottomTabBar.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(85)
        }
    }
}


// MARK: - Extension : UICollectionViewDelegateFlowLayout
extension MyGalleryPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tabIndex {
        case .first:
            return images.count + 1
        case .second:
            return 12
        case .third:
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        for subview in cell.contentView.subviews { // 모든 하위 뷰 제거
            subview.removeFromSuperview()
        }
        
        if tabIndex == .first {
            if indexPath.item == 0 {
                cell.backgroundColor = .lightGray.withAlphaComponent(0.5)
                let imageView = UIImageView(image: UIImage(named: "plusIcon"))
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.alpha = 0.5
                cell.contentView.addSubview(imageView)
                imageView.frame = cell.bounds
            } else {
                cell.backgroundColor = .clear
                let imageView = UIImageView(image: images[indexPath.item - 1])
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                cell.contentView.addSubview(imageView)
                imageView.frame = cell.bounds
            }
        } else {
            cell.backgroundColor = .lightGray
        }
        return cell
    }
}


// MARK: - Extension : UICollectionViewDataSource
extension MyGalleryPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 4) / 3
        return CGSize(width: width, height: width)
    }
}


// MARK: - Extension : UICollectionViewDelegate
extension MyGalleryPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tabIndex == .first && indexPath.item == 0 { // "+" 아이콘을 클릭할 때
            presentImagePickerController()
            
        } else if tabIndex == .first && indexPath.item == 1 {
            changeActiveTab(to: .second)
        } else if tabIndex == .first && indexPath.item == 2 {
            changeActiveTab(to: .third)
        }
    }
}


// MARK: - Extension : CustomTabBarDelegate
extension MyGalleryPageViewController: CustomTabBarDelegate {
    func didSelectTab(at index: TabIndex) {
        changeActiveTab(to: index)
    }
}


extension MyGalleryPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.insert(selectedImage, at: 0) // 이미지를 배열의 시작 부분에 추가
            collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

