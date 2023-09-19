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
    
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "buttonCell")
        return tableView
    }()
    
    
    let buttonTitles = ["Todo", "Done Tasks", "My Gallery", "Random Cat"]
    
    
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
        self.view.addSubview(tableView)
        
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear

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
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topBoxView.snp.bottom)
            make.left.right.equalTo(self.view)
            
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
        
    }
}

extension HomePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonTitles.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.tintColor = .white
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath)
        
        //화살표 흰색으로
        let accessoryImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
           accessoryImageView.tintColor = .white
           cell.accessoryView = accessoryImageView
        
        let title = buttonTitles[indexPath.row]
        
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .skyBlue
        cell.tintColor = .white

        
//        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            //전체 높이 / 셀의 개수
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
            self.navigationController?.pushViewController(myGalleryPageVC, animated: true)
        default:
            break
        }
    }
}

