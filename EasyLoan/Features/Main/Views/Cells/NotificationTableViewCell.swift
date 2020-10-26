//
//  NotificationTableViewCell.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/13/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "NotificationTableViewCell"
    
    @IBOutlet weak var conteinerView: RoundedView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.conteinerView.layer.masksToBounds = true
        self.conteinerView.layer.shadowOpacity = 0.2
        self.conteinerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.conteinerView.layer.shadowRadius = 5
        self.conteinerView.layer.shadowColor = UIColor.black.cgColor
        self.conteinerView.layer.masksToBounds = false
    }
    
    func initView(statusImage: UIImage, title: String, description: String, date: String) {
        self.statusImageView.image = statusImage
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.dateLabel.text = date
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
