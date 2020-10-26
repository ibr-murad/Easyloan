//
//  ApprovedPhotosCollectionViewCell.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/7/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SnapKit

class ApprovedPhotosCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "ApprovedPhotosCollectionViewCell"

    // MARK: - GUI Variables
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var cellImageView: UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 120))
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var cellLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = AppColors.dark.color()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    // MARKL - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.backgroundColor = .groupTableViewBackground
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.cellImageView)
        self.containerView.addSubview(self.cellLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCell(image: UIImage, description: String) {
        self.cellImageView.image = image
        self.cellLabel.text = description
        self.updateConstraintsIfNeeded()
    }
    
    // MARK: - Constraints
    
    override func updateConstraints() {
        self.containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.cellImageView.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.cellLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.cellImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
}
