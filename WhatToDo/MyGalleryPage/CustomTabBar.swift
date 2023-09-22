//
//  CustomTabBar.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/14.
//

import UIKit
import SnapKit

protocol CustomTabBarDelegate: AnyObject {
    func didSelectTab(at index: TabIndex)
}


class CustomTabBar: UIView {
    
    // MARK: - Properties
    var sliderLeadingConstraint: Constraint?
    weak var delegate: CustomTabBarDelegate?
    
    
    // MARK: - UI Components
    private let gridIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "grid")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let videoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "videoIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tagIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tagIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    //나중에 스토리보드로 작업할 가능성이 있을 때 필요한 생성자
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    // MARK: - UI Setup
    private func setupView() {
        self.backgroundColor = .white
        setupIcons()
        setupConstraints()
    }
    
    
    private func setupIcons() {
        [gridIcon, videoIcon, tagIcon].forEach { icon in
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleIconTap(_:)))
            icon.addGestureRecognizer(tap)
            icon.isUserInteractionEnabled = true
        }
    }
    
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        let stackView = UIStackView(arrangedSubviews: [gridIcon, videoIcon, tagIcon])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        addSubview(stackView)
        addSubview(sliderView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [gridIcon, videoIcon, tagIcon].forEach { icon in
            icon.snp.makeConstraints { make in
                make.height.equalTo(22.5)
            }
        }
        
        sliderView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(self.snp.width).dividedBy(3)
            make.bottom.equalTo(self)
            self.sliderLeadingConstraint = make.left.equalTo(self).constraint
        }
    }
    
    
    // MARK: - Actions
    @objc private func handleIconTap(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let tabIndex: TabIndex
        let targetX: CGFloat
        
        switch view {
        case gridIcon:
            tabIndex = .first
            targetX = 0
        case videoIcon:
            tabIndex = .second
            targetX = self.bounds.width / 3
        case tagIcon:
            tabIndex = .third
            targetX = (self.bounds.width / 3) * 2
        default:
            return
        }
        
        delegate?.didSelectTab(at: tabIndex)
        
        sliderLeadingConstraint?.update(offset: targetX)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
