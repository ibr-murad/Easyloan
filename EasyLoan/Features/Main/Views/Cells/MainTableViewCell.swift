//
//  MainTableViewCell.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/22/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MainTableViewCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.shadowOpacity = 0.1
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.containerView.layer.shadowRadius = 5
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.masksToBounds = false
    }
    
    func initView(statusImage: UIImage, name: String, type: String, date: String) {
        self.statusImageView.image = statusImage
        self.nameLabel.text = name
        self.typeLabel.text = type
        self.dateLabel.text = date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
