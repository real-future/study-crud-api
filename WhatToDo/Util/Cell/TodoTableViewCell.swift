//
//  TodoTableViewCell.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/15.
//

import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
    func checkButtonTapped(in cell: TodoTableViewCell)
    func contentAreaTapped(in cell: TodoTableViewCell)

}



class TodoTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    let checkButton: UIButton = {
        let button = UIButton()
        let circleImage = UIImage(systemName: "circle")
        button.setImage(circleImage, for: .normal) 
        button.tintColor = .darkGray
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5 // titleLabel과 dateLabel 사이의 간격 조정
        return stackView
    }()
    
    
    weak var delegate: TodoTableViewCellDelegate?
    
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        //🔴방법1
        self.contentView.bringSubviewToFront(checkButton)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentAreaTapped))
                stackView.addGestureRecognizer(tapGesture)
                stackView.isUserInteractionEnabled = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        
        addSubview(stackView)
        addSubview(checkButton)
        
//        //🔴 방법 2
//                contentView.addSubview(stackView)
//                contentView.addSubview(checkButton)
        
        
        
        
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(checkButton.snp.right).offset(16)
            make.centerY.equalTo(checkButton)
            make.right.equalToSuperview().offset(-16)
            
        }
        
        checkButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        
    }
    
    // MARK: - UI Actions
    private func setupActions() {
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func checkButtonTapped() {
        print("Button was tapped. Checking if delegate method is called next.")
        
        var isCompleted = false

        isCompleted.toggle()

        titleLabel.textColor = isCompleted ? .lightGray : .darkGray
        
        delegate?.checkButtonTapped(in: self)
    }
    
    @objc private func contentAreaTapped() {
            delegate?.contentAreaTapped(in: self)
        }
    
    func updateCheckButtonImage(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark.circle.fill" : "circle"
        let checkImage = UIImage(systemName: imageName)
        checkButton.setImage(checkImage, for: .normal)
    }
    
    func configure(isCompleted: Bool, title: String) {
          titleLabel.text = title
          titleLabel.textColor = isCompleted ? .lightGray : .darkGray
          updateCheckButtonImage(isCompleted: isCompleted)
      }
    
    func updateDateLabel(createDate: Date, modifyDate: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        var dateString = dateFormatter.string(from: createDate)
        
        if let modifyDate = modifyDate {
            dateString += " (수정됨: \(dateFormatter.string(from: modifyDate)))"
        }
        
        dateLabel.text = dateString
    }

}
