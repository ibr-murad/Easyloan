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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initView(statusImage: UIImage, name: String, time: String) {
        self.statusImageView.image = statusImage
        self.nameLabel.text = name
        self.timeLabel.text = time
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
