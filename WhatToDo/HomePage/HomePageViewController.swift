//
//  HomePageViewController.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/13.
//

import UIKit
import SnapKit

class HomePageViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var topBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private lazy var spartaLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "spartaLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WhatToDo"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .skyBlue
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Spartacodingclub Homework"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .skyBlue
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "buttonCell")
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let buttonTitles = ["Todo", "Done Tasks", "My Gallery", "Random Cat"]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .skyBlue
        [topBoxView, tableView].forEach { self.view.addSubview($0) }
        [spartaLogoImageView, titleLabel, subTitleLabel].forEach { topBoxView.addSubview($0) }
    }
    
    private func setupConstraints() {
        topBoxView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.right.equalTo(self.view)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.47)
        }

        setupTopBoxViewConstraints()
        setupTableViewConstraints()
    }

    private func setupTopBoxViewConstraints() {
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
    }

    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBoxView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }
}

// MARK: - UITableViewDataSource
extension HomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        
        let title = buttonTitles[indexPath.row]
        
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .skyBlue
        cell.tintColor = .white

        // Setup accessory view
        let accessoryImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryImageView.tintColor = .white
        cell.accessoryView = accessoryImageView
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(buttonTitles.count)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let todoPageVC = TodoPageViewController()
            self.navigationController?.pushViewController(todoPageVC, animated: true)
            
        case 1:
            let donePageVC = DonePageViewController()
            self.navigationController?.pushViewController(donePageVC, animated: true)
            
        case 2:
            let myGalleryPageVC = MyGalleryPageViewController()
            myGalleryPageVC.modalPresentationStyle = .fullScreen
            self.present(myGalleryPageVC, animated: true, completion: nil)
            
        case 3:
            let catPageVC = CatViewController()
            self.navigationController?.pushViewController(catPageVC, animated: true)
            
        default:
            break
        }
    }
}
