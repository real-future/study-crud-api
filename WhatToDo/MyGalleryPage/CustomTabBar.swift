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
    var sliderLeadingConstraint: Constraint?
    weak var delegate: CustomTabBarDelegate?

    
    //MARK: - 요소 
    let gridIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "grid")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let videoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "videoIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let tagIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tagIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let sliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //나중에 스토리보드로 작업할 가능성이 있을 때 필요한 생성자
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = .white
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
        
        
        
        let gridTap = UITapGestureRecognizer(target: self, action: #selector(handleIconTap(_:)))
        gridIcon.addGestureRecognizer(gridTap)
        gridIcon.isUserInteractionEnabled = true
        
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(handleIconTap(_:)))
        videoIcon.addGestureRecognizer(videoTap)
        videoIcon.isUserInteractionEnabled = true
        
        let tagTap = UITapGestureRecognizer(target: self, action: #selector(handleIconTap(_:)))
        tagIcon.addGestureRecognizer(tagTap)
        tagIcon.isUserInteractionEnabled = true
                
        sliderView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(self.snp.width).dividedBy(3)
            make.bottom.equalTo(self)
            self.sliderLeadingConstraint = make.left.equalTo(self).constraint
        }
    }
    
    @objc func handleIconTap(_ gesture: UITapGestureRecognizer) {
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
        
        // 애니메이션으로 슬라이더 이동
        self.sliderLeadingConstraint?.update(offset: targetX)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func didTapFirstItem() {
          delegate?.didSelectTab(at: .first)
      }

      @objc func didTapSecondItem() {
          delegate?.didSelectTab(at: .second)
      }

      @objc func didTapThirdItem() {
          delegate?.didSelectTab(at: .third)
      }
}
