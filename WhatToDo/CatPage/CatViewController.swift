//
//  CatViewController.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/20.
//

import UIKit
import SnapKit

class CatViewController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .white.withAlphaComponent(0.5)
        iv.layer.cornerRadius = 160
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3
        return iv
    }()
    
    let tapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Tap", for: .normal)
        button.setTitleColor(.skyBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .white
        ai.hidesWhenStopped = true
        return ai
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .skyBlue
        setTarget()
        setupUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        self.navigationController?.navigationBar.tintColor = .skyBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    
    func setTarget() {
        tapButton.addTarget(self, action: #selector(fetchCatImage), for: .touchUpInside)
        
    }
    
    func setNavigationBar() {
        self.title = "Random Cat"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setupUI() {
        
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(485)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(imageView)
        }
        
        view.addSubview(tapButton)
        tapButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(60)
        }
    }
    
    
    @objc func fetchCatImage() {
        activityIndicator.startAnimating()
        
        
        let url = URL(string: "https://api.thecatapi.com/v1/images/search")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Data is nil")
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstObject = jsonArray.first,
                   let imageUrlString = firstObject["url"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    self.downloadImage(from: imageUrl)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                print("Download error or Data is nil")
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
                
            }
        }
        
        task.resume()
    }
}
