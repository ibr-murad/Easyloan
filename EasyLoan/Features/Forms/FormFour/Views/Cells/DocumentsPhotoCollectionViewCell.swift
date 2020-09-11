//
//  DocumentsPhotoCollectionViewCell.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/6/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class DocumentsPhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DocumentsPhotoCollectionViewCell"
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initView(photoImage: UIImage, status: Status, type: String) {
        self.photoImageView.image = photoImage
        self.statusImageView.image = self.setStatusImage(status: status)
        self.typeLabel.text = self.setTypeText(type: type)
    }
    
    private func setStatusImage(status: Status) -> UIImage {
        var imageName = ""
        switch status {
        case .approved:
            imageName = "completedIcon"
            break
        case .warning:
            imageName = "warningIcon"
            break
        default:
            break
        }
        
        guard let statusImage = UIImage(named: imageName) else { return UIImage()}
        return statusImage
    }
    
    private func setTypeText(type: String) -> String {
        var text = ""
        switch type {
        case "PAS":
            text = "Паспорт"
            break
        case "TIN":
            text = "ИНН"
            break
        case "INC":
            text = "Спарвка доходов"
            break
        case "APP":
            text = "Заявление на кредит"
            break
        case "PHO":
            text = "Фотография клиента"
            break
        case "OTH":
            text = "Другие документы"
            break
        default:
            break
        }
        return text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
